require 'spec_helper'
require 'biju/pdu'

describe Biju::PDU::UserData do
  subject(:message) { 'Test' }
  subject(:encoded) { Biju::PDU::Encoding::GSM7Bit.encode(message) }
  subject { Biju::PDU::UserData.encode(message, encoding: :gsm7bit) }

  its(:message) { should eq(encoded[0]) }
  its(:length) { should eq(encoded[1][:length]) }
  its(:decode) { should eq(message) }
end
