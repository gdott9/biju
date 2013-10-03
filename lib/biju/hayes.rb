require 'biju/at/error'
require 'biju/at/cms_error'
require 'biju/at/cme_error'

module Biju
  class Hayes
    attr_reader :modem

    MESSAGE_STATUS = {
      unread: [0, 'REC UNREAD'],
      read: [1, 'REC UNREAD'],
      unsent: [2, ''],
      sent: [3, ''],
      all: [4, 'ALL'],
    }

    def initialize(port, options = {})
      pin = options.delete(:pin) || '0000'
      @modem = Modem.new(port, options)

      attention
      unlock_pin pin

      text_mode(false)
      extended_error
    end

    def close
      modem.close
    end

    def at_command(cmd = nil, *args, &block)
      command = ['AT', cmd].compact.join
      command_args = args.compact.to_hayes

      full_command = [command, (command_args.empty? ? nil : command_args)]
        .compact.join('=') + "\r\n"

      modem.flush
      modem.write(full_command)
      answer = hayes_to_obj(modem.wait(length: full_command.length))

      return block.call(answer) if block_given?
      answer
    end

    def attention
      at_command[:status]
    end

    def init_modem
      at_command('Z')[:status]
    end

    def phone_numbers
      result = at_command('+CNUM')
      return [] unless result.has_key?(:phone_numbers)

      result[:phone_numbers].map do |number|
        {
          number: number[:array][1].gsub(/[^0-9]/, ''),
          type_of_address: PDU::TypeOfAddress.new(number[:array][2]).to_sym
        }
      end
    end

    def text_mode(enabled = true)
      at_command('+CMGF', enabled)[:status]
    end

    def text_mode?(force = false)
      @text_mode = at_command('+CMGF?')[:result] if @text_mode.nil? || force
      @text_mode
    end

    def extended_error(enabled = true)
      at_command('+CMEE', enabled)[:status]
    end

    def prefered_storage(pms = nil)
      result = at_command('+CPMS', pms)
      return result[:array] if result[:cmd] == '+CPMS'
      nil
    end

    def pin_status
      at_command('+CPIN?')[:result]
    end

    def unlock_pin(pin)
      at_command('+CPIN', pin)[:status] if pin_status == 'SIM PIN'
    end

    def messages(which = :all)
      which = MESSAGE_STATUS[which][text_mode? ? 1 : 0] if which.is_a?(Symbol)

      sms = at_command('+CMGL', which)

      return [] unless sms.has_key?(:sms)
      sms[:sms].map do |msg|
        Biju::Sms.from_pdu(msg[:message].chomp, msg[:infos][0])
      end
    end

    # Delete a sms message by id.
    # @param [Fixnum] Id of sms message on modem.
    def delete(id)
      id = [id] if id.kind_of?(Fixnum)
      return unless id.kind_of?(Enumerable)

      res = true
      id.each { |i| res &= at_command('+CMGD', i)[:status] }

      res
    end

    def send(sms, options = {})
      result = at_command('+CMGS', (sms.to_pdu.length - 2) / 2)

      if result[:prompt]
        modem.write("#{sms.to_pdu}#{26.chr}")
        res = ''
        loop do
          res = modem.wait(length: 8)
          break unless res.match(/\A[0-9A-Fa-f]+\r\n\z/)
        end
        hayes_to_obj(res.lstrip)
      end
    end

    private

    def hayes_to_obj(str)
      res = ATTransform.new.apply(ATParser.new.parse(str))

      case res[:cmd]
      when '+CMS ERROR'
        raise AT::CmsError.new(res[:result])
      when '+CME ERROR'
        raise AT::CmeError.new(res[:result])
      end

      res
    end
  end
end
