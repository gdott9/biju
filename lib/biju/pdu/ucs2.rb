module Biju
  module PDU
    class UCS2
      def self.decode(string, length: 0)
        string.scan(/.{4}/).map { |char| char.hex.chr('UCS-2BE') }.join
          .encode('UTF-8', 'UCS-2BE')
      end

      def self.encode(string)
        [
          string.encode('UCS-2BE').chars.map { |char| "%04x" % char.ord }.join,
          length: string.length * 2,
        ]
      end
    end
  end
end
