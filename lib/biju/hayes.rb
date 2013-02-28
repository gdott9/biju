module Biju
  class Hayes
    attr_accessor :command, :attributes, :ok
    attr_reader :answer

    #def method_missing(m, *args, &block)
    #end

    def attention
      at_command { |response| response =~ /OK/ }
      #at_command { |response| true }
    end

    def init_modem
      at_command('Z') { |response| response =~ /OK/ }
    end

    def text_mode(enabled = true)
      at_command('+CMGF', enabled) { |response| response =~ /OK/ }
    end

    def prefered_storage?
      at_command('+CPMS') { |response| response =~ /OK/ }
    end

    def answer=(ret)
      @answer = ret
      ok?
    end

    def ok?
      ok.nil? ? true : !ok.call(answer).nil?
    end

    private

    def at_command(cmd = nil, *args, &block)
      option_prefix = nil #options[:prefix] || nil
      cmd_root = ['AT', cmd].compact.join(option_prefix)
      cmd_args = args.compact.map { |arg| to_hayes_string(arg) } unless args.empty?
      self.command = [cmd_root, cmd_args].compact.join('=')
      self.ok = block if block_given?
      command
    end

    def hayes_to_obj(str)
    end

    # OPTIMIZE : add () to array
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
      at_command("+CPIN=#{to_hayes_string(pin)}") { |response| response =~ /OK/ }
    end
  end
end
