module Biju
  module PDU
    class DataCodingScheme
      DATA_CODING_SCHEME = {
        gsm7bit: 0,
        gsm8bit: 4,
        ucs2: 8,
        reserved: 12,
      }

      def self.autodetect(message)
        message.chars.each do |char|
          return :ucs2 unless GSM7Bit::BASIC_7BIT_CHARACTER_SET.include?(char) ||
            GSM7Bit::BASIC_7BIT_CHARACTER_SET_EXTENSION.has_value?(char)
        end

        :gsm7bit
      end

      def initialize(dcs, options = {})
        unless dcs.is_a?(Symbol)
          dcs = dcs.hex if dcs.is_a?(String)
          if dcs & 0b11000000 == 0
            dcs = DATA_CODING_SCHEME.key(dcs & 0b00001100)
          else
            raise "Unsupported"
          end
        end

        @dcs = dcs
      end

      def to_sym
        @dcs
      end

      def hex
        DATA_CODING_SCHEME[@dcs]
      end
    end
  end
end
