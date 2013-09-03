require 'date'

module Biju
  class Sms
    attr_accessor :id, :phone_number, :message
    attr_reader :datetime

    def initialize(params={})
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params
    end

    def datetime=(arg)
      @datetime = case arg
      when String
        DateTime.strptime(arg, "%y/%m/%d,%T")
      when DateTime
        arg
      else
        nil
      end
    end

    def to_s
      "#{id} - #{phone_number} - #{datetime} - #{message}"
    end
  end
end
