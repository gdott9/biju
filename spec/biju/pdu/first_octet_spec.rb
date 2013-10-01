require 'spec_helper'
require 'biju/pdu'

describe Biju::PDU::FirstOctet do
  its(:reply_path?) { should be_false }
  its(:user_data_header?) { should be_false }
  its(:status_report_request?) { should be_false }
  its(:reject_duplicates?) { should be_false }

  its(:message_type_indicator) { should eq(:sms_deliver) }
  its(:validity_period_format) { should eq(:not_present) }
end
