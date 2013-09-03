require 'serialport'

module Biju
  class Modem
    DEFAULT_OPTIONS = { baud: 9600, data_bits: 8,
                        stop_bits: 1, parity: SerialPort::NONE }

    attr_reader :connection

    # @param [Hash] Options to serial connection.
    # @option options [String] :port The modem port to connect
    #
    #   Biju::Modem.new('/dev/ttyUSB0')
    #
    def initialize(port, options = {})
      @connection = SerialPort.new(port, DEFAULT_OPTIONS.merge!(options))
    end

    # Close the serial connection.
    def close
      connection.close
    end

    def write(text)
      connection.write(text + "\r")
    end

    def wait_answer
      buffer = ''
      while IO.select([connection], [], [], 0.25)
        buffer << connection.getc.chr
      end

      buffer
    end
  end
end
