require 'spec_helper'
require 'biju/parser'

describe Biju::ATParser do
  context "status" do
    it "returns ok status" do
      result = Biju::ATTransform.new.apply(Biju::ATParser.new.parse("OK\r"))
      expect(result).to include(status: true)
    end

    it "returns error status" do
      result = Biju::ATTransform.new.apply(Biju::ATParser.new.parse("ERROR\r"))
      expect(result).to include(status: false)
    end
  end

  context "response" do
    it "parses messages list" do
      messages = '+CMGL: 1,"REC READ","+85291234567",,"07/02/18,01:12:12+32"' <<
                  "\r" <<
                  "Reading text messages is easy.\r" <<
                  '+CMGL: 2,"REC READ","+85291234567",,"07/02/18,00:07:22+32"' <<
                  "\r" <<
                  "A simple demo of SMS text messaging.\r" <<
                  '+CMGL: 3,"REC READ","+85291234567",,"07/02/18,00:12:05+32"' <<
                  "\r" <<
                  "Hello, welcome to our SMS tutorial.\r" <<
                  "\r" <<
                  "OK\r"
      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(messages))

      expect(result).to include(status: true)
      expect(result[:sms]).to have(3).messages
      expect(result[:sms][0][:message]).to eq('Reading text messages is easy.')
    end

    it "gets messages storage" do
      pms = "+CPMS: ((\"SM\",\"BM\",\"SR\"),(\"SM\"))\r"

      result = Biju::ATTransform.new.apply(
        Biju::ATParser.new.parse(pms))

      expect(result[:cmd]).to eq('+CPMS')
      expect(result[:array]).to have(2).storage
      expect(result[:array][0]).to have(3).storage
    end
  end

  it "raises ParseFailed exception" do
    expect { Biju::ATParser.new.parse('Ha') }.to raise_error(Parslet::ParseFailed)
  end
end
