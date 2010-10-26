require 'spec_helper'
require 'smstraderb/response'

describe SMSTradeRB::Response do
  let (:response) { "100\n123456789\n0.055\n1" }

  it "will raise an exception if the response string is nil" do
    expect {
      SMSTradeRB::Response.new(nil)
    }.to raise_error(SMSTradeRB::InvalidResponse)
  end

  it "will raise an exception with an empty response string" do
    expect {
      SMSTradeRB::Response.new("")
    }.to raise_error(SMSTradeRB::InvalidResponse)
  end

  it "will raise an exception if the response string does not start with an integer" do
    expect {
      SMSTradeRB::Response.new("abc")
    }.to raise_error(SMSTradeRB::InvalidResponse)
  end

  it "will raise an exception if the response code is unknown" do
    expect {
      SMSTradeRB::Response.new("12134234123420")
    }.to raise_error(SMSTradeRB::UnknownResponse)
  end

  describe "#code" do
    it "returns the response code" do
      SMSTradeRB::Response.new(response).code.should == 100
    end
  end

  describe "#message_id" do
    it "returns the message id" do
      SMSTradeRB::Response.new(response).message_id.should == '123456789'
    end

    it "returns nil if the message_id is missing" do
      SMSTradeRB::Response.new("100\n\n0.44").message_id.should be_nil
    end
  end

  describe "#cost" do
    it "returns the cost as a float" do
      SMSTradeRB::Response.new(response).cost.should == 0.055
    end

    it "returns nil if the cost is missing" do
      SMSTradeRB::Response.new('100').cost.should be_nil
    end
  end

  describe "#count" do
    it "returns the sms count as an integer" do
      SMSTradeRB::Response.new(response).count.should == 1
    end

    it "returns nil if the count is missing" do
      SMSTradeRB::Response.new("100\n\n\n\n\n").count.should be_nil
    end
  end

  describe "#ok?" do
    it "returns true if the return code is 100" do
      SMSTradeRB::Response.new("100\n\n\n\n\n").should be_ok
    end
  end

  describe "#error?" do
    it "returns true if the return code is not 100" do
      SMSTradeRB::Response.new("40").should be_error
    end
  end

  describe "#response_message" do
    it "returns an message for the return code" do
      SMSTradeRB::Response.new("40").response_message.should == SMSTradeRB::RESPONSE_CODES[40]
    end
  end
end
