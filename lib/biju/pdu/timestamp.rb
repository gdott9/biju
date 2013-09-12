require 'date'

module Biju
  module PDU
    class Timestamp
      attr_reader :timestamp

      def initialize(timestamp)
        @timestamp = timestamp
      end

      def timezone
        # The last 2 digits of the timestamp are for the timezone
        timezone = timestamp[-2, 2].reverse.hex

        # The MSB define the plus-minus sign. 0 for +, 1 for -
        sign = (timezone >> 7 == 0 ? '+' : '-')

        # The following 3 bits represent tens digit
        # and the last 4 bits are for the units digit
        tens_digit = ((timezone & 0b01110000) >> 4)
        units_digit = (timezone & 0b00001111)

        # Timezone is in quarters of an hour
        sign << '%02d' % ((tens_digit * 10 + units_digit) / 4)
      end

      def to_datetime
        DateTime.strptime(
          "#{timestamp[0..-3].reverse}#{timezone}", '%S%M%H%d%m%y%Z')
      end
    end
  end
end
