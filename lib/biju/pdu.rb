require 'biju/pdu/encoding/gsm7bit'
require 'biju/pdu/encoding/ucs2'

require 'biju/pdu/user_data'
require 'biju/pdu/data_coding_scheme'

require 'biju/pdu/first_octet'
require 'biju/pdu/timestamp'
require 'biju/pdu/phone_number'
require 'biju/pdu/type_of_address'

module Biju
  module PDU
    def self.encode(phone_number, message, type_of_address: :international)
      phone_number = PhoneNumber.encode(phone_number)
      user_data = UserData.encode(message)
      first_octet = FirstOctet.new.message_type_indicator!(:sms_submit)

      [
        # Length of SMSC information
        # 0 means the SMSC stored in the phone should be used
        '00',
        # First octet
        '%02x' % first_octet.binary,
        # TP-Message-Reference
        '00',
        "%02x" % phone_number.length,
        "%02x" % phone_number.type_of_address.hex,
        phone_number.number,
        # TP-PID: Protocol identifier
        '00',
        "%02x" % user_data.encoding.hex,
        "%02x" % user_data.length,
        user_data.message
      ].join
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
        timestamp: Timestamp.new(string[38, 14]).to_datetime,
        user_data_length: string[52..53],
      }
      res[:sender_number] = PhoneNumber.new(
        string[22, res[:address_length] + (res[:address_length].odd? ? 1 : 0)],
        type_of_address: res[:address_type])
      res[:user_data] = UserData.new(message: string[54..-1],
        encoding: res[:data_coding_scheme],
        length: res[:user_data_length].hex)

      res
    end
  end
end
