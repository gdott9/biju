require 'parslet'
require 'date'

module Biju
  class ATParser < Parslet::Parser
    root :at_string

    rule(:at_string) { request | response }

    # REQUEST
    rule(:request) do
      str('+++') | str('A/') | (prefix >> (cr.absent? >> lf.absent? >> any).repeat(0)) >>
      (cr >> crlf >> response).maybe
    end
    rule(:prefix) { str('AT') | str('at') }

    # RESPONSE
    rule(:response) { ((command.maybe >> status) | merror) >> crlf | prompt }
    rule(:prompt) { str('> ').as(:prompt) }
    rule(:command) { mgl | num | pin | mgf | mgs | generic_response }

    rule(:merror) do
      (str('+CME ERROR') | str('+CMS ERROR')).as(:cmd) >> str(': ') >>
        int.as(:result)
    end

    rule(:mgl) do
      (str('+CMGL').as(:cmd) >> str(': ') >> infos >> crlf >> message >> crlf)
        .repeat(1).as(:sms) >> crlf
    end
    rule(:num) do
      (str('+CNUM').as(:cmd) >> str(': ') >> array >> crlf)
        .repeat(1).as(:phone_numbers) >> crlf >> crlf
    end
    rule(:mgf) do
      str('+CMGF').as(:cmd) >> str(': ') >> boolean.as(:result) >> crlf >> crlf
    end
    rule(:pin) do
      str('+CPIN').as(:cmd) >> str(': ') >> eol.as(:result) >> crlf >> crlf
    end
    rule(:mgs) do
      str('+CMGS').as(:cmd) >> str(': ') >> int.as(:result) >> crlf >> crlf
    end
    rule(:generic_response) do
      match('[^:]').repeat(1).as(:cmd) >> str(': ') >> array >>
      crlf >> crlf
    end

    rule(:array) do
      (data >> (comma >> data).repeat).as(:array)
    end
    rule(:data) { (str('(') >> array >> str(')')) | info }
    rule(:infos) { (info >> (comma >> info).repeat).as(:infos) }
    rule(:info) { datetime | string | int | empty_string }
    rule(:message) { match('[0-9A-Fa-f]').repeat(1).as(:message) }

    # MISC
    rule(:status) { (ok | error).as(:status) }
    rule(:ok) { str('OK').as(:ok) }
    rule(:error) { str('ERROR').as(:error) }

    rule(:cr) { str("\r") }
    rule(:lf) { str("\n") }
    rule(:crlf) { cr >> lf }
    rule(:comma) { str(',') }
    rule(:quote) { str('"') }

    rule(:empty_string) { str('').as(:empty_string) }
    rule(:string) { quote >> match('[^\"]').repeat.as(:string) >> quote }
    rule(:int) { match('[0-9]').repeat(1).as(:int) }
    rule(:boolean) { match('[01]').as(:boolean) }
    rule(:eol) { (crlf.absent? >> any).repeat.as(:string) }

    rule(:datetime) { quote >> (date >> str(',') >> time).as(:datetime) >> quote }
    rule(:date) do
      (match('[0-9]').repeat(2) >> str('/')).repeat(2) >> match('[0-9]').repeat(2)
    end
    rule(:time) do
      (match('[0-9]').repeat(2) >> str(':')).repeat(2) >> match('[0-9]').repeat(2) >>
      match('[-+]') >> match('[0-9]').repeat(2)
    end
  end

  class ATTransform < Parslet::Transform
    rule(prompt: simple(:prompt)) { { prompt: true } }
    rule(cmd: simple(:cmd), infos: subtree(:infos), message: simple(:message)) do
      { cmd: cmd.to_s, infos: infos, message: message.to_s }
    end
    rule(cmd: simple(:cmd), array: subtree(:array)) do
      { cmd: cmd.to_s, array: array }
    end
    rule(cmd: simple(:cmd), result: simple(:result)) do
      { cmd: cmd.to_s, result: result }
    end

    rule(empty_string: simple(:empty_string)) { '' }
    rule(int: simple(:int)) { int.to_i }
    rule(boolean: simple(:boolean)) { boolean.to_i > 0 }
    rule(string: simple(:string)) { string.to_s }
    rule(datetime: simple(:datetime)) do
      DateTime.strptime(datetime.to_s, '%y/%m/%d,%T%Z')
    end
    rule(array: subtree(:array)) { array }

    rule(status: simple(:status)) { { status: status } }
    rule(ok: simple(:ok)) { true }
    rule(error: simple(:error)) { false }
  end
end
