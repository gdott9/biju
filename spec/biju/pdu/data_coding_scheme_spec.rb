# encoding: UTF-8
require 'spec_helper'
require 'biju/pdu'

describe Biju::PDU::DataCodingScheme do
  describe '::autodetect' do
    it "autodetects gsm7bit encoding" do
      [
        "Test",
        "Ç$",
        "[teßt}",
      ].each do |string|
        expect(Biju::PDU::DataCodingScheme.autodetect(string)).to eq(:gsm7bit)
      end
    end

    it "autodetects ucs2 encoding" do
      [
        "ç",
        "âmazing",
      ].each do |string|
        expect(Biju::PDU::DataCodingScheme.autodetect(string)).to eq(:ucs2)
      end
    end
  end

  subject { Biju::PDU::DataCodingScheme.new(:gsm7bit) }
  its(:to_sym) { should eq(:gsm7bit) }
  its(:hex) { should eq(0) }
end
