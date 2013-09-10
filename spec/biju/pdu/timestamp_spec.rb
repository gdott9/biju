require 'spec_helper'
require 'biju/pdu'

describe Biju::PDU::Timestamp do
  subject { Biju::PDU::Timestamp.new('31900141039580') }

  its(:timezone) { should eq('+02') }
  its(:to_datetime) { should eq(DateTime.new(2013, 9, 10, 14, 30, 59, '+02')) }
end
