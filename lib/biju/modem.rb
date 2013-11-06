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

    def flush
      wait(length: 0, timeout: 0)
    end

    def wait(options = {})
      length = options[:length] || 0
      timeout = options[:timeout] || 10

      buffer = ''
      Timeout.timeout(timeout) do
        while IO.select([connection], [], [], 0.25) || buffer.length < length
          buffer << connection.getc.chr
        end
      end

      buffer
    end
  end
end
