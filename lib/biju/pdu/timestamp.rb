module Biju
  module PDU
    class Timestamp
      attr_reader :timestamp

      def initialize(timestamp)
        @timestamp = timestamp
      end

      def timezone
        timezone = timestamp[-2, 2].reverse.hex

        sign = (timezone >> 7 == 0 ? '+' : '-')
        tens_digit = ((timezone & 0b01110000) >> 4)
        units_digit = (timezone & 0b00001111)

         sign << '%02d' % ((tens_digit * 10 + units_digit) / 4)
      end

      def to_datetime
        DateTime.strptime(
          "#{timestamp[0..-3].reverse}#{timezone}", '%S%M%H%d%m%y%Z')
      end
    end
  end
end
