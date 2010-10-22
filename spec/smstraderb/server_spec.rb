require 'spec_helper'
require 'smstraderb/server'

describe SMSTradeRB::Server do
  def app
    SMSTradeRB::Server.new
  end

  before(:each) do
    @params = {
      :key => 'secret-key',
      :route => 'basic',
      :to => '123',
      :message => 'message text'
    }
  end

  describe "#new" do
    it "takes an options hash" do
      rack_app = SMSTradeRB::Server.new(:testop => 'foobar')
      rack_app[:testop].should == 'foobar'
    end
  end

  it "responds with the code in the :code option" do
    def app
      SMSTradeRB::Server.new(:code => 999)
    end
    get '/', @params do |response|
      response.body.should == '999'
    end
  end

  it "responds to the '/' url" do
    get '/' do |response|
      response.should be_ok
    end
  end

  it "responds with '10' if no recipient is set" do
    @params.delete(:to)
    get '/', @params do |response|
      response.body.should == '10'
    end
  end

  it "responds with '10' if the recipient format is wrong" do
    @params[:to] = 'abcde'
    get '/', @params do |response|
      response.body.should == '10'
    end
  end

  it "responds with '30' if no message text is set" do
    @params.delete(:message)
    get '/', @params do |response|
      response.body.should == '30'
    end
  end

  it "responds with '31' if the message type is invalid" do
    @params[:messagetype] = 'foobar'
    get '/', @params do |response|
      response.body.should == '31'
    end
  end

  it "responds with '40' if no route is set" do
    @params.delete(:route)
    get '/', @params do |response|
      response.body.should == '40'
    end
  end

  it "responds with '40' if an invalid route is set" do
    @params[:route] = 'foobar'
    get '/', @params do |response|
      response.body.should == '40'
    end
  end

  it "responds with '50' if no key is set" do
    @params.delete(:key)
    get '/', @params do |response|
      response.body.should == '50'
    end
  end

  describe "optional parameter" do
    describe "message_id" do
      it "responds with the message id in the second line" do
        @params[:message_id] = '1'
        get '/', @params do |response|
          response.body.should == "100\n123456789"
        end
      end
    end

    describe "cost" do
      it "responds with the costs in the third line" do
        @params[:cost] = '1'
        get '/', @params do |response|
          response.body.should == "100\n\n0.055"
        end
      end
    end

    describe "count" do
      it "responds with the sms count in the fourth line" do
        @params[:count] = '1'
        get '/', @params do |response|
          response.body.should == "100\n\n\n1"
        end
      end
    end
  end

  describe "call inspection" do
    it "provides access to the received params" do
      @rack_app = SMSTradeRB::Server.new
      def app
        @rack_app
      end
      get '/', @params

      @rack_app.params['message'].should == @params[:message]
    end
  end
end
