require 'serialport'
require 'forwardable'

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

    def wait
      buffer = ''
      while IO.select([connection], [], [], 0.25)
        buffer << connection.getc.chr
      end

      buffer
    end
  end
end
