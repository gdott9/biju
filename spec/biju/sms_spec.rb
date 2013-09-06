require 'spec_helper'
require 'biju'

describe Biju::Sms do
  subject do
    Biju::Sms.new(
      id: 1,
      phone_number: "144",
      datetime: "11/07/28,15:34:08-12",
      message: "Some text here")
  end

  its(:id) { should eq(1) }
  its(:phone_number) { should eq("144") }
  its(:datetime) { should eq(DateTime.new(2011, 7, 28, 15, 34, 8, '-12')) }
  its(:message) { should eq("Some text here") }

  describe '::from_pdu' do
    subject do
      Biju::Sms.from_pdu(
        '07913396050066F3040B913366666666F600003190509095928004D4F29C0E')
    end

    its(:datetime) { should eq(DateTime.new(2013, 9, 5, 9, 59, 29, '+08')) }
    its(:message) { should eq('Test') }
  end
end
