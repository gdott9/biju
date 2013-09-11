require 'spec_helper'
require 'biju/parser'

describe Biju::ATParser do
  context "status" do
    it "returns ok status" do
      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse("AT\r\r\nOK\r\n"))
      expect(result).to include(status: true)
    end

    it "returns error status" do
      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse("AT\r\r\nERROR\r\n"))
      expect(result).to include(status: false)
    end
  end

  context "errors" do
    it "parses CMS ERROR" do
      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse("AT\r\r\n+CMS ERROR: 500\r\n"))
      expect(result[:cmd]).to eq('+CMS ERROR')
      expect(result[:result]).to eq(500)
    end

    it "parses CME ERROR" do
      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse("AT\r\r\n+CME ERROR: 100\r\n"))
      expect(result[:cmd]).to eq('+CME ERROR')
      expect(result[:result]).to eq(100)
    end
  end

  context "response" do
    it "parses cmgs prompt" do
      mgs = "AT+CMGS=18\r\r\n> "

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(mgs))

      expect(result).to include(prompt: true)
    end

    it "parses messages list" do
      messages = "AT+CMGL=1\r\r\n" <<
                  "+CMGL: 0,1,,23\r\n" <<
                  "07913396050066F3040B91336789\r\n" <<
                  "+CMGL: 3,1,,74\r\n" <<
                  "BD60B917ACC68AC17431982E066BC5642205F3C95400\r\n" <<
                  "+CMGL: 4,1,,20\r\n" <<
                  "07913396050066F3040B913364446864\r\n" <<
                  "\r\n" <<
                  "OK\r\n"
      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(messages))

      expect(result).to include(status: true)
      expect(result[:sms]).to have(3).messages
      expect(result[:sms][0][:message]).to eq('07913396050066F3040B91336789')
    end

    it "gets phone numbers" do
      pms = "AT+CNUM\r\r\n+CNUM: \"M\",\"+33666666666\",145\r\n\r\n\r\nOK\r\n"

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(pms))

      expect(result[:phone_numbers][0][:cmd]).to eq('+CNUM')
      expect(result[:phone_numbers]).to have(1).phone_number
      expect(result[:phone_numbers][0][:array][1]).to eq('+33666666666')
    end

    it "gets messages storage" do
      pms = "AT+CPMS=?\r\r\n+CPMS: ((\"SM\",\"BM\",\"SR\"),(\"SM\"))\r\n\r\nOK\r\n"

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(pms))

      expect(result[:cmd]).to eq('+CPMS')
      expect(result[:array]).to have(2).storage
      expect(result[:array][0]).to have(3).storage
    end

    it "gets specified message storage infos" do
      pms = "AT+CPMS=\"MT\"\r\r\n+CPMS: 23,23,7,100,7,100\r\n\r\nOK\r\n"

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(pms))

      expect(result).to include(status: true)
      expect(result[:array]).to have(6).storage
      expect(result[:array]).to eq([23, 23, 7, 100, 7, 100])
    end

    it "parses +CMGF? response" do
      mgf = "AT+CMGF?\r\r\n+CMGF: 0\r\n\r\nOK\r\n"

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(mgf))

      expect(result).to include(status: true)
      expect(result[:result]).to be_false
    end

    it "parses message sent response" do
      mgs = "+CMGS: 163\r\n\r\nOK\r\n"

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(mgs))

      expect(result).to include(status: true)
      expect(result[:result]).to eq(163)
    end
  end

  it "raises ParseFailed exception" do
    expect { Biju::ATParser.new.parse('Ha') }.to raise_error(Parslet::ParseFailed)
  end
end
