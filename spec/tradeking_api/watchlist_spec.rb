require 'spec_helper'

describe TradeKing::Watchlist do
  let(:client){
    TradeKing::Client.new({
      consumer_key: TRADEKING_CONSUMER_KEY,
      consumer_secret: TRADEKING_CONSUMER_SECRET,
      oauth_token: TRADEKING_OAUTH_TOKEN,
      oauth_secret: TRADEKING_OAUTH_SECRET
    })
  }
  let(:id){ 'test-list' }
  let(:symbols){ ['AAPL', 'TSLA'] }

  describe ".new" do
    use_vcr_cassette "watchlist_new"

    let(:watchlist) { client.watchlist.create({id: id, symbols: symbols.join(',')}) }

    it "should not raise exception" do
       expect { watchlist }.to_not raise_error
    end

    it "should not be nil or empty" do
       watchlist.should_not be_nil
    end

    it "should contain Watchlist Instance" do
       watchlist.first.should be_an_instance_of(TradeKing::Watchlist)
    end
  end

  describe ".find" do
    use_vcr_cassette "watchlist_find"
    let(:watchlist){ client.watchlists.find(id) }

    it "should find an existing watchlist" do
      watchlist.should_not be_nil
    end

    it "should be a Watchlist Instance" do
      watchlist.should be_an_instance_of(TradeKing::Watchlist)
    end

    it "should respond to ID" do
      watchlist.should respond_to(:id)
    end

    it "should contain items" do
      watchlist.items.should_not be_empty
    end

    describe "items" do

      let(:item){
        watchlist.items.first
      }

      it "should respond to costbasis" do
        item.should respond_to(:costbasis)
        item.costbasis.should_not be_nil
      end
      it "should respond to qty" do
        item.should respond_to(:qty)
        item.qty.should_not be_nil
      end

      it "should respond to symbol" do
        item.should respond_to(:symbol)
        item.symbol.should_not be_nil
      end
    end
  end

  describe ".list" do
    use_vcr_cassette "watchlist_list"
    let(:watchlists){ client.watchlists.all }

    it "should list watchlists" do
      watchlists.should_not be_empty
    end

    it "should list watchlists" do
      watchlists.should_not be_nil
    end

    it "should list watchlists" do
      @watchlists = client.watchlists.all
      @watchlists.should_not be_empty
      @watchlists.each do |list|
        list.should be_an_instance_of(TradeKing::Watchlist)
      end
    end
  end

  describe ".add" do
    use_vcr_cassette "watchlist_add"
    let(:watchlist){ client.watchlists.find(id) }
    let(:action){ watchlist.add('NFLX') }

    it "should add symbol to watchlist" do
      expect { action }.to_not raise_error
    end
  end

  describe ".delete" do
    use_vcr_cassette "watchlist_delete"
    let(:watchlist){ client.watchlists.find(id) }
    let(:action){ watchlist.delete('NFLX') }

    it "should add symbol to watchlist" do
      expect { action }.to_not raise_error
    end
  end

  describe ".delete" do
     use_vcr_cassette "watchlist_delete"
     let(:watchlists){ client.watchlists.delete(id) }

     it "should delete watchlist" do
       expect { watchlists }.to_not raise_error
     end

     it "should be empty" do
       watchlists.items.should be_empty
     end
   end
end