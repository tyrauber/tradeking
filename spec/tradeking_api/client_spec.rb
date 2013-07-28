require 'spec_helper'

describe TradekingApi::Client do

  # describe "client initialization" do
  # 
  #   it 'should not initialize without a consumer_key and consumer_secret' do
  #     lambda { TradekingApi::Client.new() }.should raise_error
  #   end
  # 
  #   it 'should initialize with a valid consumer_key and consumer_secret' do
  #     lambda { 
  #       TradekingApi::Client.new({
  #         consumer_key: CONSUMER_KEY, 
  #         consumer_secret: CONSUMER_SECRET
  #       })
  #     }.should_not raise_error
  #   end
  # end
  # 
  # describe ".access_token" do
  # 
  #   it 'should not get valid access token with invalid consumer' do
  #     lambda { 
  #       client = TradekingApi::Client.new({
  #           consumer_key: 'BADTOKEN', 
  #           consumer_secret: 'BADSECRET'
  #           access_token:  OAUTH_TOKEN,
  #           access_secret: OAUTH_SECRET
  #         })
  #       client.access_token(@consumer, OAUTH_TOKEN, OAUTH_SECRET)
  #     }.should raise_error
  #   end
  # 
  #   it 'should initialize with a valid consumer_key and consumer_secret' do
  #     lambda { TradekingApi::Client.new(CONSUMER_KEY, CONSUMER_SECRET) }.should_not raise_error
  #   end
  #end
  describe ".new" do
    let(:client){
       TradekingApi::Client.new({
          consumer_token: CONSUMER_TOKEN,
          consumer_secret: CONSUMER_SECRET
        })
    }
  
    it 'should be valid' do
      lambda { client }.should_not raise_error
    end

    it 'should have valid consumer' do
      client.consumer.should_not be_nil
      client.consumer.key.should == CONSUMER_TOKEN
      client.consumer.secret.should == CONSUMER_SECRET
      client.consumer.options[:signature_method].should == "HMAC-SHA1"
      client.consumer.options[:oauth_version].should == "1.0"
      client.consumer.options[:site].should == "https://api.tradeking.com"
    end
  end
  
  describe ".update" do
    let(:client){
      TradekingApi::Client.new({
        consumer_token: CONSUMER_TOKEN,
        consumer_secret: CONSUMER_SECRET
      })
    }
  
    it 'should be valid' do
      lambda {
        client.update({
           access_token: ACCESS_TOKEN,
           access_secret: ACCESS_SECRET
         })
      }.should_not raise_error
    end

    it 'should have valid token' do
      client.update({
        access_token: ACCESS_TOKEN,
        access_secret: ACCESS_SECRET
      })
      puts client.token.inspect
      # client.consumer.should_not be_nil
      # client.consumer.key.should == CONSUMER_TOKEN
      # client.consumer.secret.should == CONSUMER_SECRET
      # client.consumer.options[:signature_method].should == "HMAC-SHA1"
      # client.consumer.options[:oauth_version].should == "1.0"
      # client.consumer.options[:site].should == "https://api.tradeking.com"
    end
  end
end