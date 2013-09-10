module Biju
  module PDU
    class PhoneNumber
      attr_accessor :type_of_address, :number

      def self.encode(number, type_of_address: :international)
        number = number + 'F' if number.length.odd?
        new(
          number.scan(/../).map(&:reverse).join,
          type_of_address: type_of_address
        )
      end

      def initialize(number, type_of_address: :international)
        self.number = number
        self.type_of_address = TypeOfAddress.new(type_of_address)
      end

      def decode
        number.scan(/../).map(&:reverse).join.chomp('F')
      end

      def length
        number.length - (number[-2, 2].hex >> 4 == 15 ? 1 : 0)
      end
    end
  end
end
