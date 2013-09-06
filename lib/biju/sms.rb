require 'date'

module Biju
  class Sms
    attr_accessor :id, :phone_number, :message
    attr_reader :datetime

    def self.from_pdu(string)
      sms_infos = PDU.decode(string)
      new(phone_number: sms_infos[:sender_number],
          datetime: sms_infos[:timestamp],
          message: sms_infos[:user_data])
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
    end
  end
end
