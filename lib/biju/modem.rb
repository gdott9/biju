require 'serialport'
require 'forwardable'
require 'timeout'

module Biju
  class Modem
    extend Forwardable

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

    def_delegators :connection, :close, :write

    def wait(length: 0)
      buffer = ''
      Timeout.timeout(10) do
        while IO.select([connection], [], [], 0.50) || buffer.length < length
          buffer << connection.getc.chr
        end
      end

      buffer
    end
  end
end
