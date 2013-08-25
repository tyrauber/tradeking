module TradeKing
  class Market

    TOPLISTS = ['toplosers', 'toppctlosers', 'topvolume', 'topactive', 'topgainers', 'toppctgainers', 'topactivegainersbydollarvalue']

    attr_accessor :id, :options, :client, :path

    TOPLISTS.each do |list|
      self.class.send(:define_method, list) do |options|
        toplists({ list: list, client: options.delete(:client) })
      end
    end

    def self.path
      "market"
    end

    def self.clock(options={})
      options[:client].get("market/clock", {})
    end
    
    def self.quote(options={})
      client = options.delete(:client)
      symbols = {symbols: options.delete(:args).join(",")}
      url = "market/ext/quotes"
      request = TradeKing::Request.new(resource: TradeKing::Quote, client: client, path: '')
      request.collection_from_response(:post, url, symbols)
    end
    
    def self.stream(options={})
      client = options.delete(:client)
      symbols = {symbols: options.delete(:args)}
      url = "https://stream.tradeking.com/v1/market/quotes.json"
      client.stream(url, symbols)
    end
    
    def self.timesales(options={})
      #=> params:  'symbols', 'startdate', 'interval', 'rpp', 'index','enddate', 'starttime'
      client = options.delete(:client)
      url = "market/timesales"
      params= options[:args][0]
      request = TradeKing::Request.new(resource: TradeKing::Timesale, client: client, path: '')
      request.collection_from_response(:get, url, params)
    end

    protected

    def self.toplists(options={})
      client = options.delete(:client)
      list = options[:list]
      url = "market/toplists/#{list}.json"
      request = TradeKing::Request.new(resource: TradeKing::Toplist, client: client, path: '')
      request.collection_from_response(:get, url, {})
    end
  end
end