require 'spec_helper'

describe TradeKing::Option do
  let(:client){
    TradeKing::Client.new({
      consumer_key: TRADEKING_CONSUMER_KEY,
      consumer_secret: TRADEKING_CONSUMER_SECRET,
      access_token: TRADEKING_OAUTH_TOKEN,
      access_token_secret: TRADEKING_OAUTH_SECRET
    })
  }
  describe ".search" do
    let(:params){ { symbol: "TSLA", query: "xyear-eq:2013 AND xmonth-eq:08 AND strikeprice-gt:250" } }
    let(:query){ client.options.search(params) }
    
    use_vcr_cassette "options_search"
    
    it "should be valid" do
      lambda { query }.should_not raise_error
    end

    it "should contain quotes" do
      query.should_not be_empty
      query.each do |quote|
        quote.should be_an_instance_of(TradeKing::Option)
      end
    end

    it "should contain quotes" do
      query.should_not be_empty
      query.each do |quote|
        quote.should be_an_instance_of(TradeKing::Option)
      end
    end
    TradeKing::Option.new.fields.each do | field|
      it "should respond to #{field}" do
        query.first.should.respond_to?(field)
      end
    end
  end

  describe ".expirations" do
    let(:params){ "TSLA" }
    let(:query){ client.options.expirations(params) }

    use_vcr_cassette "options_expirations"

    it "should be valid" do
      lambda { query }.should_not raise_error
    end

    it "should be be option instance" do
      query.should be_an_instance_of(TradeKing::Option)
      query.should.respond_to?(:symbol)
      query.should.respond_to?(:dates)
    end
  end

  describe ".strikes" do
    let(:params){ "TSLA" }
    let(:query){ client.options.strikes(params) }

    use_vcr_cassette "options_strikes"

    it "should be valid" do
      lambda { query }.should_not raise_error
    end

    it "should be be option instance" do
      query.should be_an_instance_of(TradeKing::Option)
      query.should.respond_to?(:symbol)
      query.should.respond_to?(:strikes)
    end
  end
end