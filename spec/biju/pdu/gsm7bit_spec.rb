require 'spec_helper'
require 'biju/pdu/gsm7bit'

describe Biju::PDU::GSM7Bit do
  describe '::decode' do
    it "decodes string" do
      expect(Biju::PDU::GSM7Bit.decode('D4F29C0E', length: 4)).to eq('Test')
    end

    it "decodes character from extension set" do
      expect(Biju::PDU::GSM7Bit.decode('9B32', length: 2)).to eq('€')
    end

    it "decodes character with a length of 7" do
      expect(Biju::PDU::GSM7Bit.decode('E170381C0E8701', length: 7)).to eq('a' * 7)
    end
  end

  describe '::encode' do
    it "encodes string" do
      expect(Biju::PDU::GSM7Bit.encode('Test').first.upcase).to eq('D4F29C0E')
    end

    it "encodes character from extension set" do
      expect(Biju::PDU::GSM7Bit.encode('€').first.upcase).to eq('9B32')
    end

    it "encodes character with a length of 7" do
      expect(Biju::PDU::GSM7Bit.encode('a' * 7).first.upcase).to eq('E170381C0E8701')
    end
  end

  it "gives same text after encoding and decoding" do
    strings = [
      'My first TEST',
      '{More complicated]',
      'And on€ More~',
      'a' * 7,
    ]

    strings.each do |string|
      expect(Biju::PDU::GSM7Bit.decode(
        *Biju::PDU::GSM7Bit.encode(string))).to eq(string)
    end
  end
end
