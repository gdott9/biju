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
    def self.encode(phone_number, message, options = {})
      type_of_address = options[:type_of_address] || :international

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
        '%02x' % phone_number.length,
        '%02x' % phone_number.type_of_address.hex,
        phone_number.number,
        # TP-PID: Protocol identifier
        '00',
        '%02x' % user_data.encoding.hex,
        '%02x' % user_data.length,
        user_data.message
      ].join
    end

    def self.decode(string)
      octets = string.scan(/../)

      smsc_length = octets.shift.hex
      smsc_number = octets.shift(smsc_length)

      first_octet = FirstOctet.new(octets.shift.hex)

      address_length = octets.shift.hex
      address_type = octets.shift.hex
      sender_number = PhoneNumber.new(
        octets.shift(
          (address_length.odd? ? address_length.succ : address_length) / 2).join,
        type_of_address: address_type)

      protocol_identifier = octets.shift
      data_coding_scheme = octets.shift
      timestamp = Timestamp.new(octets.shift(7).join).to_datetime
      user_data_length = octets.shift.hex

      user_data = UserData.new(message: octets.join,
        encoding: data_coding_scheme,
        length: user_data_length)

      {
        smsc_length: smsc_length,
        smsc_number: smsc_number,

        first_octet: first_octet,

        address_length: address_length,
        address_type: address_type,
        sender_number: sender_number,

        protocol_identifier: protocol_identifier,
        data_coding_scheme: data_coding_scheme,
        timestamp: timestamp,
        user_data_length: user_data_length,
        user_data: user_data
      }
    end
  end
end
