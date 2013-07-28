require 'spec_helper'

describe TradekingApi::Client::Watchlist do
  let(:client){
    TradekingApi::Client.new({
      consumer_token: CONSUMER_TOKEN,
      consumer_secret: CONSUMER_SECRET,
      access_token: ACCESS_TOKEN,
      access_secret: ACCESS_SECRET
    })
  }
  describe ".new" do
    it "should create new watchlist" do
      #puts client.watchlist.new
    end
  end
end