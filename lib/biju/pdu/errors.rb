module Biju
  module PDU
    module Errors
      class PDUError < ::StandardError
      end

      class MalformedSms < PDUError
        attr_reader :original_exception
        attr_reader :pdu, :id

        def initialize(pdu, id, original_exception = nil)
          @id = id
          @pdu = pdu
          @original_exception = original_exception
        end

        def to_s
          "This SMS can not be parsed: #{pdu} (#{original_exception.class}: #{original_exception})"
        end
      end

      class DataCodingSchemeNotSupported < PDUError
        attr_reader :data_coding_scheme

        def initialize(dcs = nil)
          @data_coding_scheme = dcs
        end

        def to_s
          "This data coding scheme (0b#{data_coding_scheme.to_s(2)}) is not supported"
        end
      end

      class EncodingNotSupported < PDUError
      end
    end
  end
end
