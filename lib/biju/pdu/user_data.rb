module Biju
  module PDU
    class UserData
      ENCODING = {
        gsm7bit: GSM7Bit,
        ucs2: UCS2,
      }

      attr_accessor :encoding, :message, :length

      def self.encode(message, encoding: nil)
        encoding = DataCodingScheme.autodetect(message) if encoding.nil?

        raise ArgumentError, 'Unknown encoding' unless ENCODING.has_key?(encoding)
        res = ENCODING[encoding].encode(message)

        new(message: res[0], length: res[1][:length], encoding: encoding)
      end

      def initialize(message: '', length: 0, encoding: :gsm7bit)
        self.encoding = DataCodingScheme.new(encoding)
        self.message = message
        self.length = length
      end

      def decode
        ENCODING[encoding.to_sym].decode(message, length: length)
      end
    end
  end
end
