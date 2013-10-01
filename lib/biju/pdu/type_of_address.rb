module Biju
  module PDU
    class TypeOfAddress
      TYPE_OF_ADDRESS = {
        unknown: 0b10000001,
        international: 0b10010001,
        national: 0b10100001,
        reserved: 0b11110001,
      }

      def initialize(type_of_address, options = {})
        type_of_address = :international if type_of_address.nil?

        unless type_of_address.is_a?(Symbol)
          type_of_address = type_of_address.hex if type_of_address.is_a?(String)
          type_of_address = TYPE_OF_ADDRESS.key(type_of_address)
        end
        @type_of_address = type_of_address
      end

      def to_sym
        @type_of_address
      end

      def hex
        TYPE_OF_ADDRESS[@type_of_address]
      end
    end
  end
end
