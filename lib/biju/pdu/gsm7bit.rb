module Biju
  module PDU
    class GSM7Bit
      BASIC_7BIT_CHARACTER_SET = [
        '@', '£', '$', '¥', 'è', 'é', 'ù', 'ì', 'ò', 'Ç', "\n", 'Ø', 'ø', "\r", 'Å', 'å',
        "\u0394", '_', "\u03a6", "\u0393", "\u039b", "\u03a9", "\u03a0","\u03a8", "\u03a3", "\u0398", "\u039e", "\e", 'Æ', 'æ', 'ß', 'É',
        ' ', '!', '"', '#', '¤', '%', '&', '\'', '(', ')','*', '+', ',', '-', '.', '/',
        '0', '1', '2', '3', '4', '5', '6', '7','8', '9', ':', ';', '<', '=', '>', '?',
        '¡', 'A', 'B', 'C', 'D', 'E','F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
        'P', 'Q', 'R', 'S','T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Ä', 'Ö', 'Ñ', 'Ü', '§',
        '¿', 'a','b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
        'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'ä', 'ö', 'ñ','ü', 'à'
      ]

      BASIC_7BIT_CHARACTER_SET_EXTENSION = {
        0x0A => "\n",
        0x0D => '',
        0x14 => '^',
        0x1B => '',
        0x28 => '{',
        0x29 => '}',
        0x2F => '\\',
        0x3C => '[',
        0x3D => '~',
        0x3E => ']',
        0x40 => '|',
        0x65 => '€',
      }

      def self.decode(string, length: 0)
        res = ''
        next_char = 0

        string.scan(/../).map(&:hex).each_with_index do |octet, i|
          index = i % 7
          current = ((octet & (2 ** (7 - index) - 1)) << index) | next_char

          res = add_char(res, current)

          next_char = octet >> (7 - index)
          if index == 6
            res = add_char(res, next_char)
            next_char = 0
          end
        end

        res[0..(length - 1)]
      end

      def self.encode(string)
        res = ''
        string.chars.each do |char|
          if get_septet(char)
            res << get_septet(char).reverse
          elsif get_septet(char, escape: true)
            res << get_septet("\e").reverse
            res << get_septet(char, escape: true).reverse
          end
        end
        res << ("0" * (8 - (res.length % 8))) unless res.length % 8 == 0

        res.scan(/.{8}/).map { |octet| "%02x" % octet.reverse.to_i(2) }.join
      end

      private

      def self.add_char(string, char)
        if string[-1] == "\e"
          string.chop << BASIC_7BIT_CHARACTER_SET_EXTENSION[char]
        else
          string << BASIC_7BIT_CHARACTER_SET[char]
        end
      end

      def self.get_septet(char, escape: false)
        char = (!escape ? BASIC_7BIT_CHARACTER_SET.index(char) : BASIC_7BIT_CHARACTER_SET_EXTENSION.key(char))

        return nil unless char
        "%07b" % char
      end
    end
  end
end
