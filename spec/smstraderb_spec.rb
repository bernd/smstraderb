require 'spec_helper'
require 'smstraderb'
require 'smstraderb/server'

describe SMSTradeRB do
  it "sets the key if it's initialized with the :key option" do
    SMSTradeRB.new(:key => 'myapikey').key.should == 'myapikey'
  end

  it "sets the message if initialized with the :message option" do
    SMSTradeRB.new(:message => 'mymessage').message.should == 'mymessage'
  end

  describe "to option" do
    it "sets the recipient (to) if initialized with the :to option" do
      SMSTradeRB.new(:to => '123456').to.should == '123456'
    end

    it "raises an exception if the number is invalid" do
      lambda {
        SMSTradeRB.new(:to => '123456abc')
      }.should raise_error(SMSTradeRB::InvalidFormat)
    end

    it "removes whitespace" do
      SMSTradeRB.new(:to => '12 34  56').to.should == '123456'
    end

    it "removes dashes (-)" do
      SMSTradeRB.new(:to => '12-34-56').to.should == '123456'
    end

    it "removes parenthesis" do
      SMSTradeRB.new(:to => '(123)456').to.should == '123456'
    end

    it "allows phone numbers with a country prefix" do
      SMSTradeRB.new(:to => '+49 12345').to.should == '+4912345'
    end
  end

  describe "from option" do
    context "route set to :gold" do
      it "allows the from option to be set" do
        SMSTradeRB.new(:route => :gold, :from => '123456').from.should == '123456'
      end
    end

    context "route set to :direct" do
      it "allows the from option to be set" do
        SMSTradeRB.new(:route => :direct, :from => '123456').from.should == '123456'
      end
    end

    it "raises an exception if route is not :gold or :direct" do
      lambda {
        SMSTradeRB.new(:from => '123456').from.should == '123456'
      }.should raise_error(SMSTradeRB::InvalidOption)
    end

    it "verifies the length (max 11)" do
      lambda {
        SMSTradeRB.new(:route => :gold, :from => 'ab cd sdfses')
      }.should raise_error(SMSTradeRB::InvalidFormat)
    end
  end

  describe "routes" do
    it "sets the route if initialized with the :route option" do
      SMSTradeRB.new(:route => :gold).route.should == :gold
    end

    it "sets the route to :basic by default" do
      SMSTradeRB.new.route.should == :basic
    end

    it "raises an exception on invalid routes" do
      lambda {
        SMSTradeRB.new(:route => :eeek_invalid)
      }.should raise_error(SMSTradeRB::InvalidRoute)
    end
  end

  describe "additional options and attributes" do
    describe "debug" do
      it "it returns 1 if set to true" do
        SMSTradeRB.new(:debug => true).debug.should be(1)
      end

      it "it returns 0 if set to false" do
        SMSTradeRB.new(:debug => false).debug.should be(0)
      end
    end

    it "has a charset attribute" do
      SMSTradeRB.new.charset.should_not be_nil
    end
  end

  describe "#message" do
    it "returns an urlencoded string" do
      SMSTradeRB.new(:message => 'f$oo bar').message.should == 'f%24oo+bar'
    end
  end

  describe "#from" do
    it "returns an urlencoded string" do
      SMSTradeRB.new(:route => :gold, :from => 'f$oo bar').from.should == 'f%24oo+bar'
    end
  end

  describe "#send" do
    context "success" do
      it "returns a response object" do
        Artifice.activate_with(SMSTradeRB::Server.new(:code => 999)) do
          sms = SMSTradeRB.new(:route => :basic, :key => 'mykey', :debug => false)
          sms.send(:to => '1234', :message => 'my message').code.should be(999)
        end
      end
    end
  end
end
