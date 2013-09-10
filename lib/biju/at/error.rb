module Biju
  module AT
    class Error < ::Exception
      ERRORS = {
        1 => 'Unknown error',
      }

      def initialize(id, default = 1)
        @error_id = (self.class::ERRORS.has_key?(id) ? id : default)
      end

      def to_s
        "#{self.class::ERRORS[@error_id]} (#{@error_id})"
      end
    end
  end
end
