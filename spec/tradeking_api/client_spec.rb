require 'spec_helper'

describe TradeKing::Client do
  describe ".new" do
    describe "valid consumer" do
      let(:client){
         TradeKing::Client.new({
            consumer_key: TRADEKING_CONSUMER_KEY,
            consumer_secret: TRADEKING_CONSUMER_SECRET
          })
      }
      it 'should be valid' do
        lambda { client }.should_not raise_error
      end

      it 'should have valid consumer' do
        client.consumer.should_not be_nil
        client.consumer.key.should == TRADEKING_CONSUMER_KEY
        client.consumer.secret.should == TRADEKING_CONSUMER_SECRET
        client.consumer.options[:signature_method].should == "HMAC-SHA1"
        client.consumer.options[:oauth_version].should == "1.0"
        client.consumer.options[:site].should == "https://api.tradeking.com"
      end
    end

    describe "invalid consumer" do
      let(:client){
         TradeKing::Client.new({
            consumer_key: '',
            consumer_secret: ''
          })
      }
      it 'should be valid' do
        lambda { client }.should raise_error
      end
    end
  end
  
  describe ".update" do
    let(:client){
      TradeKing::Client.new({
        consumer_key: TRADEKING_CONSUMER_KEY,
        consumer_secret: TRADEKING_CONSUMER_SECRET
      })
    }
  
    it 'should be valid' do
      lambda {
        client.authorize({
           oauth_token: TRADEKING_OAUTH_TOKEN,
           oauth_secret: TRADEKING_OAUTH_SECRET
         })
      }.should_not raise_error
    end

    it 'should have valid token' do
      client.authorize({
        oauth_token: TRADEKING_OAUTH_TOKEN,
        oauth_secret: TRADEKING_OAUTH_SECRET
      })
      client.token.token.should_not be_nil
      client.token.secret.should_not be_nil
    end
  end
end