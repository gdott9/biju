require 'spec_helper'
require 'biju/sms'

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
  its(:datetime) { should eq(DateTime.new(2011, 7, 28, 15, 34, 8)) }
  its(:message) { should eq("Some text here") }
end
