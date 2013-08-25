require 'spec_helper'

describe TradeKing::Article do
  let(:client){
    TradeKing::Client.new({
      consumer_key: TRADEKING_CONSUMER_KEY,
      consumer_secret: TRADEKING_CONSUMER_SECRET,
      access_token: TRADEKING_OAUTH_TOKEN,
      access_token_secret: TRADEKING_OAUTH_SECRET
    })
  }
  describe ".search" do
    let(:params){ { symbols: "TSLA" } }
    let(:query){ client.articles.search(params) }
    
    use_vcr_cassette "articles_search"
    
    it "should be valid" do
      lambda { query }.should_not raise_error
    end
    
    it "should contain articles" do
      query.should_not be_empty
      query.each do |article|
        article.should be_an_instance_of(TradeKing::Article)
      end
    end
  end
end