require 'parslet'
require 'date'

module Biju
  class ATParser < Parslet::Parser
    root :at_string

    rule(:at_string) { request | response }

    # REQUEST
    rule(:request) { str('+++') | str('A/') | (prefix >> (crlf.absent? >> any).repeat) }
    rule(:prefix) { str('AT') | str('at') }

    # RESPONSE
    rule(:response) { (status | command) >> crlf }
    rule(:command) { mgl | pms | mserror }

    rule(:mserror) { str('+CMS ERROR').as(:cmd) >> str(': ') >> message }
    rule(:mgl) do
      (str('+CMGL').as(:cmd) >> str(': ') >> infos >> crlf >> message >> crlf).repeat.as(:sms) >>
      crlf >> status
    end
    rule(:pms) do
      str('+CPMS').as(:cmd) >> str(': ') >> str('(').maybe >> array >> str(')').maybe
    end

    rule(:array) do
      (data >> (comma >> data).repeat).as(:array)
    end
    rule(:data) { (str('(') >> array >> str(')')) | info }
    rule(:infos) { (info >> (comma >> info).repeat).as(:infos) }
    rule(:info) { datetime | string | int | empty_string }
    rule(:message) { match('[0-9A-Fa-f]').repeat.as(:message) }

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
    rule(cmd: simple(:cmd), infos: subtree(:infos), message: simple(:message)) do
      {cmd: cmd.to_s, infos: infos, message: message.to_s}
    end
    rule(cmd: simple(:cmd), array: subtree(:array)) do
      {cmd: cmd.to_s, array: array}
    end

    rule(empty_string: simple(:empty_string)) { '' }
    rule(int: simple(:int)) { int.to_i }
    rule(string: simple(:string)) { string.to_s }
    rule(datetime: simple(:datetime)) { DateTime.strptime(datetime.to_s, "%y/%m/%d,%T%Z") }
    rule(array: subtree(:array)) { array }

    rule(status: simple(:status)) { { status: status } }
    rule(ok: simple(:ok)) { true }
    rule(error: simple(:error)) { false }
  end
end
