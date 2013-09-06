require 'biju/pdu/gsm7bit'
require 'biju/pdu/ucs2'

module Biju
  module PDU
    ENCODING = {
      gsm7bit: GSM7Bit,
      ucs2: UCS2,
    }

    def self.encode(hash)
    end

    def self.encode_user_data(message, encoding = :gsm7bit)
      raise ArgumentError, "Unknown encoding" unless ENCODING.has_key?(encoding)
      ENCODING[encoding].encode(message)
    end

    def self.decode(string)
      res = {
        smsc_length: string[0..1],
        smsc_type: string[2..3],
        smsc_number: string[4..15],

        address_length: string[18..19].to_i(16),
        address_type: string[20..21],

        protocol_identifier: string[34..35],
        data_coding_scheme: string[36..37],
        timestamp: DateTime.strptime(
          "#{string[38..49].reverse}+#{string[50..51].reverse}",
          '%S%M%H%d%m%y%Z'),
        user_data_length: string[52..53],
      }
      res[:sender_number] = string[22..(22 + res[:address_length])].scan(/../)
        .map(&:reverse).join.chop
      res[:user_data] = PDU.decode_user_data(string[54..-1],
        encoding: res[:data_coding_scheme],
        length: res[:user_data_length].hex)

      res
    end

    def self.decode_user_data(message, encoding: '00', length: 0)
      encoding = data_coding_scheme(encoding) unless encoding.is_a?(Symbol)

      raise ArgumentError, "Unknown encoding" unless ENCODING.has_key?(encoding)
      ENCODING[encoding].decode(message, length: length)
    end

    def self.data_coding_scheme(dcs)
      dcs = dcs.hex if dcs.is_a?(String)
      if dcs & 0b11000000 == 0
        case dcs & 0b00001100
        when 0
          :gsm7bit
        when 4
          :gsm8bit
        when 8
          :ucs2
        when 12
          :reserved
        end
      end
    end
  end
end
