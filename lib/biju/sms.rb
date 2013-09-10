require 'date'

module Biju
  class Sms
    attr_reader :id, :phone_number, :type_of_address, :message, :datetime

    def self.from_pdu(string, id = nil)
      sms_infos = PDU.decode(string)
      new(id: id,
          phone_number: sms_infos[:sender_number].decode,
          type_of_address: sms_infos[:sender_number].type_of_address.to_sym,
          datetime: sms_infos[:timestamp],
          message: sms_infos[:user_data].decode)
    end

    def initialize(params = {})
      params.each do |attr, value|
        instance_variable_set(:"@#{attr}", value)
      end if params
    end

    def to_s
      "[#{id}] (#{phone_number}) #{datetime} '#{message}'"
    end

    def to_pdu
      Biju::PDU.encode(phone_number, message, type_of_address: type_of_address)
    end
  end
end
