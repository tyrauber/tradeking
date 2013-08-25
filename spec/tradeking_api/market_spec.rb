require 'spec_helper'

describe TradeKing::Market do
  let(:client){
    TradeKing::Client.new({
      consumer_key: TRADEKING_CONSUMER_KEY,
      consumer_secret: TRADEKING_CONSUMER_SECRET,
      access_token: TRADEKING_OAUTH_TOKEN,
      access_token_secret: TRADEKING_OAUTH_SECRET
    })
  }
  describe ".clock" do
    
    use_vcr_cassette "market_clock"

    it "should be valid" do
      lambda { client.market.clock }.should_not raise_error
    end
    
    it "should respond to status" do
      client.market.clock.should.respond_to?("status")
    end
    
    it "should respond to message" do
      client.market.clock.should.respond_to?("message")
    end
    
    it "should respond to date" do
      client.market.clock.should.respond_to?("date")
    end
    
    it "should respond to unix_time" do
      client.market.clock.should.respond_to?("unix_time")
    end
    
    describe "status" do
      let(:clock){
        client.market.clock
      }

      it "should respond to status.current" do
        clock["status"].should.respond_to?("current")
      end
      
      it "should respond to status.next" do
        clock["status"].should.respond_to?("next")
      end
      
      it "should respond to status.change_at" do
        clock["status"].should.respond_to?("change_at")
      end
    end
  end
  describe ".quote" do

    use_vcr_cassette "market_quote"
    let(:stocks){ ['AAPL', 'TSLA', 'NFLX']}
    let(:quotes){
      client.market.quote(stocks)
    }

    it "should be valid" do
      lambda { quotes }.should_not raise_error
    end
    
    it "should contain quotes" do
      quotes.should_not be_empty
      quotes.each do |quote|
        quote.should be_an_instance_of(TradeKing::Quote)
      end
    end
    
    TradeKing::Quote.new.fields.each do | field |
      it "should respond to #{field}" do
        quotes.first.should.respond_to?(field)
      end
    end
  end

  describe ".toplists" do
    TradeKing::Market::TOPLISTS.each do |list|
      describe ".#{list}" do
        use_vcr_cassette "market_#{list}"
        let(:query){ client.market.send(list) }
        it "should be valid" do
          lambda { query }.should_not raise_error
        end
        it "should contain toplists" do
          query.should_not be_empty
          query.each do |list|
            list.should be_an_instance_of(TradeKing::Toplist)
          end
        end
        TradeKing::Toplist.new.fields.each do | field|
          it "should respond to #{field}" do
            query.first.should.respond_to?(field)
          end
        end
      end
    end
  end

  describe ".timesales" do
    use_vcr_cassette "market_timesales"

    let(:query){
      client.market.timesales(symbols: "TSLA", startdate: "13-08-08")
    }
      
    it "should be valid" do
      lambda { query }.should_not raise_error
    end

    it "should contain quotes" do
      query.should_not be_empty
      query.each do |quote|
        quote.should be_an_instance_of(TradeKing::Timesale)
      end
    end
  end
end