module Biju
  module PDU
    class FirstOctet
      FIRST_OCTET = {
        reply_path: 0b10000000,
        user_data_header: 0b01000000,
        status_report_request: 0b00100000,
        validity_period_format: 0b00011000,
        reject_duplicates: 0b00000100,
        message_type_indicator: 0b00000011,
      }

      MESSAGE_TYPE_INDICATOR = {
        sms_deliver: 0b00000000,
        sms_submit: 0b00000001,
        sms_status: 0b00000010,
        reserved: 0b00000011,
      }

      VALIDITY_PERIOD_FORMAT = {
        not_present: 0b00000000,
        reserved: 0b00001000,
        relative: 0b00010000,
        absolute: 0b00011000,
      }

      attr_accessor :binary

      def initialize(first_octet = 0)
        self.binary = first_octet
      end

      def get(field)
        binary & FIRST_OCTET[field]
      end

      [:reply_path, :user_data_header, :status_report_request,
       :reject_duplicates].each do |sym|
        define_method :"#{sym}?" do
          get(sym) > 0
        end

        define_method :"#{sym}!" do |value = true|
          if value
            self.binary |= FIRST_OCTET[sym]
          else
            self.binary &= (FIRST_OCTET[sym] ^ 0b11111111)
          end
          self
        end
      end

      [:message_type_indicator, :validity_period_format].each do |sym|
        define_method sym do
          self.class.const_get(sym.upcase).key(get(sym))
        end

        define_method :"#{sym}!" do |value|
          hash = self.class.const_get(sym.upcase)

          self.binary = ((binary & (FIRST_OCTET[sym] ^ 0b11111111)) |
                         hash[value]) unless hash[value].nil?
          self
        end
      end
    end
  end
end
