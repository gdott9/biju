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
      init_modem
      unlock_pin pin

      text_mode(false)
      extended_error
    end

    def at_command(cmd = nil, *args, &block)
      command = ['AT', cmd].compact.join
      command_args = args.compact.to_hayes

      full_command = [command, (command_args.empty? ? nil : command_args)]
        .compact.join('=')

      modem.write(full_command + "\r\n")
      answer = hayes_to_obj(modem.wait)

      return block.call(answer) if block_given?
      answer
    end

    def attention
      at_command[:status]
    end

    def init_modem
      at_command('Z')[:status]
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

    def unlock_pin(pin)
      at_command('+CPIN', pin)[:status]
    end

    def messages(which = :all)
      which = MESSAGE_STATUS[which][text_mode? ? 1 : 0] if which.is_a?(Symbol)

      sms = at_command('+CMGL', which)

      return sms[:status] if !sms.has_key?(:sms) || sms[:sms].empty?
      sms[:sms].map do |msg|
        Biju::Sms.from_pdu(msg[:message].chomp, msg[:infos][0])
      end
    end

    # Delete a sms message by id.
    # @param [Fixnum] Id of sms message on modem.
    def delete(id)
      at_command('+CMGD', id)
    end

    def send(sms, options = {})
      at_command('+CMGS', sms.phone_number)

      write("#{sms.message}#{26.chr}")
      hayes_to_obj(modem.wait)
    end

    private

    def hayes_to_obj(str)
      ATTransform.new.apply(ATParser.new.parse(str))
    end
  end
end
