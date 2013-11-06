module Biju
  module PDU
    class UserData
      ENCODING = {
        gsm7bit: Encoding::GSM7Bit,
        ucs2: Encoding::UCS2,
      }

      attr_accessor :encoding, :message, :length, :user_data_header

      def self.encode(message, options = {})
        encoding = options[:encoding] || DataCodingScheme.autodetect(message)

        raise ArgumentError, 'Unknown encoding' unless ENCODING.has_key?(encoding)
        res = ENCODING[encoding].encode(message)

        new(message: res[0], length: res[1][:length], encoding: encoding)
      end

      def initialize(options = {})
        self.encoding = DataCodingScheme.new(options[:encoding] || :gsm7bit)
        self.message = options[:message] || ''

        self.length = options[:length] || 0

        self.user_data_header = options[:user_data_header] || false
      end

      def decode
        ENCODING[encoding.to_sym].decode(message, length: length)
      end
    end
  end
end
