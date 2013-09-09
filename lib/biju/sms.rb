require 'date'

module Biju
  class Sms
    attr_accessor :id, :phone_number, :type_of_address, :message
    attr_reader :datetime

    def self.from_pdu(string, id = nil)
      sms_infos = PDU.decode(string)
      new(id: id,
          phone_number: sms_infos[:sender_number].decode,
          type_of_address: sms_infos[:sender_number].type_of_address.to_sym,
          datetime: sms_infos[:timestamp],
          message: sms_infos[:user_data].decode)
    end

    def initialize(params={})
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params
    end

    def datetime=(arg)
      @datetime = case arg
      when String
        DateTime.strptime(arg, "%y/%m/%d,%T%Z")
      when DateTime
        arg
      else
        nil
      end
    end

    def to_s
      "[#{id}] (#{phone_number}) #{datetime} '#{message}'"
    end

    def to_pdu
      Biju::PDU.encode(phone_number, message, type_of_address: type_of_address)
    end
  end
end
