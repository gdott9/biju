module Biju
  class Hayes
    attr_accessor :command, :attributes, :ok
    attr_reader :answer

    #def method_missing(m, *args, &block)
    #end

    def attention
      basic_command { |response| response =~ /OK/ }
      #basic_command { |response| true }
    end

    def init_modem
      basic_command('Z') { |response| response =~ /OK/ }
    end

    def text_mode(enabled = true)
      extended_command('CMGF', enabled) { |response| response =~ /OK/ }
    end

    def prefered_storage?
      extended_command('CPMS') { |response| response =~ /OK/ }
    end

    def answer=(ret)
      @answer = ret
      ok?
    end

    def ok?
      ok.nil? ? true : !ok.call(answer).nil?
    end

    private

    def basic_command(cmd = nil, options = {}, *args, &block)
      option_prefix = options[:prefix] || nil
      cmd_root = ['AT', cmd].compact.join(option_prefix)
      cmd_args = args.compact.map { |arg| to_hayes_string(arg) } unless args.empty?
      self.command = [cmd_root, cmd_args].compact.join('=')
      self.ok = block if block_given?
      command
    end

    def extended_command(cmd = nil, *args, &block)
      basic_command(cmd, {:prefix => '+'}, *args, &block)
    end

    def hayes_to_obj(str)
    end

    def to_hayes_string(arg)
      case arg
      when String
        "\"#{arg}\""
      when Array
        arg.join(',')
      when TrueClass, FalseClass
        !!arg ? 1 : 0
      else
        "?"
      end
    end
  end

  class HayesSms < Hayes
    def unlock_pin(pin)
      send_command("AT+CPIN=#{to_hayes_string(pin)}") { |response| response =~ /OK/ }
    end
  end
end
