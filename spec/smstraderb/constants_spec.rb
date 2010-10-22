require 'spec_helper'
require 'smstraderb/constants'

describe SMSTradeRB, "Constants" do
  it "provides a VERSION constant" do
    SMSTradeRB::VERSION.should_not be_nil
  end

  it "provides a HTTP_GATEWAY constant" do
    SMSTradeRB::HTTP_GATEWAY.should_not be_nil
  end

  it "provides a HTTPS_GATEWAY constant" do
    SMSTradeRB::HTTPS_GATEWAY.should_not be_nil
  end

  it "provides the RESPONSE_CODES constat containing a hash" do
    SMSTradeRB::RESPONSE_CODES.should be_a(Hash)
  end

  it "provides the MESSAGE_TYPES constant" do
    SMSTradeRB::MESSAGE_TYPES.should_not be_nil
  end
end
