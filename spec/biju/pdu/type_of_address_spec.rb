require 'spec_helper'
require 'biju/pdu'

describe Biju::PDU::TypeOfAddress do
  subject { Biju::PDU::TypeOfAddress.new(:international) }

  its(:to_sym) { should eq(:international) }
  its(:hex) { should eq(145) }
end
