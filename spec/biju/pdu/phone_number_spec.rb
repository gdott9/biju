require 'spec_helper'
require 'biju/pdu'

describe Biju::PDU::PhoneNumber do
  describe '::encode' do
    subject { Biju::PDU::PhoneNumber.encode('33123456789') }
    its(:number) { should eq('3321436587F9') }
  end

  context "odd length" do
    subject { Biju::PDU::PhoneNumber.new('3321436587F9') }
    its(:decode) { should eq('33123456789') }
    its(:length) { should eq(11) }
  end

  context "even length" do
    subject { Biju::PDU::PhoneNumber.new('3321436587') }
    its(:decode) { should eq('3312345678') }
    its(:length) { should eq(10) }
  end
end
