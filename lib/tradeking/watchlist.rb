module TradeKing
  class Watchlist < Request

    attr_accessor :id, :options, :client, :path, :lists, :items, :request_path
    #has_many :symbols

    def initialize(options={})
      @id = options['id'] if options['id'].present?
      @items = options['items'].present? ? options['items'].map{|item| TradeKing::WatchlistItem.new(item) } : []
      @client = options['client']
    end
    
    class << self
      attr_accessor :request_path
    end
    
    def self.path
      "watchlists"
    end

    def add(symbols=[])
      url = "watchlists/#{self.id}/symbols"
      request = TradeKing::Request.new(resource: self.class, client: client)
      request.collection_from_response(:post, url, {symbols: symbols})
    end
    
    def delete(symbol)
      url = "watchlists/#{self.id}/symbols/#{symbol}"
      request = TradeKing::Request.new(resource: self.class, client: client)
      request.collection_from_response(:delete, url, {})
    end

    def destroy
      delete(self.id)
    end

    def self.parse_object(options={})
      if !!(options['watchlists']['watchlist']['watchlistitem'] rescue false)
        {'id' => self.request_path.last, 'items' => options['watchlists']['watchlist']['watchlistitem']}
      elsif !!(options['watchlists']['watchlist'] rescue false)
        options['watchlists']['watchlist']
      else
        options
      end
    end
    
    def self.parse_collection(options={})
      collection = []
      if options['watchlists'].present?
        options['watchlists']['watchlist'].each do |list|
          collection.push({list[0] => list[1]})
        end
      end
      return collection
    end
  end
end