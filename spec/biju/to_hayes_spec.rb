require 'spec_helper'
require 'biju/to_hayes'

describe "blah blah" do
  it { expect(5.to_hayes).to eq('5') }
  it { expect(true.to_hayes).to eq('1') }
  it { expect(false.to_hayes).to eq('0') }
  it { expect("test".to_hayes).to eq('"test"') }
  it { expect([1, 2].to_hayes).to eq('1,2') }
end
