# TradeKing

A TradeKing Api Ruby Gem. Create and manage watchlists.

## Installation

Add this line to your application's Gemfile:

    gem 'tradeking'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tradeking

## API Approval

In order to use the TradeKing gem, you will need a TradeKing Account and have requested, AND received approval for, API Access.

After creating an API Application you will receive the following four items:

* Consumer Key
* Consumer Secret
* OAuth Token
* OAuth Token Secret

The consumer key and secret are your application keys, while the oauth token and secret are your personal keys.

To use this gem you must have these items and access must be approved by TradeKing.

For more information:: [developers.tradeking.com](https://developers.tradeking.com)

## Usage

### TradeKing::Client

#### 1. TradeKing::Client.new()
##### params: consumer_key, consumer_secret

With valid a valid consumer_token and consumer secret:

    @client = TradeKing::Client.new({ consumer_key: "Consumer Key", consumer_secret: "Consumer Secret" })

TradeKing::Client.new() will return a client instance with a consumer object.

#### 1. @client.authorize()
##### params: access_token, access_token_secret

Using a valid client, and with a valid access_token and access_token_secret:

    @client.authorize({ access_token: "OAuth Token", access_token_secret: "Oauth Secret" })

@client.login() will return the client instance, now with an access token, which will enable queries on behalf of the oauth user.

#### 1. @client.watchlists.all

@client.watchlists.all

#### 1. Create Watchlist
##### @client.watchlists.create({id:"", symbols:[] })

@client.watchlists.create({id:"", symbols:[] })

#### 1. Find Watchlist
##### @client.watchlists.find(id)

watchlist = @client.watchlists.find(id)

watchlist.add(symbols)
watchlist.delete(symbols)

@client.watchlists.delete(id)

@client.market.clock
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
