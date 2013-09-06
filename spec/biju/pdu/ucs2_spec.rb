require 'spec_helper'
require 'biju/pdu/ucs2'

describe Biju::PDU::UCS2 do
  describe '::decode' do
    it "decodes string" do
      expect(Biju::PDU::UCS2.decode('00C700E700E200E300E500E4016B00F80153', length: 4)).to eq('Ççâãåäūøœ')
    end
  end

  describe '::encode' do
    it "encodes string" do
      expect(Biju::PDU::UCS2.encode('Ççâãåäūøœ').upcase).to eq('00C700E700E200E300E500E4016B00F80153')
    end
  end

  it "gives same text after encoding and decoding" do
    strings = [
      'My first TEST',
      '{More çomplicated]',
      'And on€ More~',
      'þß®',
    ]

    strings.each do |string|
      expect(Biju::PDU::UCS2.decode(
        Biju::PDU::UCS2.encode(string), length: string.length)).to eq(string)
    end
  end
end
