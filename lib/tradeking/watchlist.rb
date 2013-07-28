module TradeKing
  class Watchlist
  
    attr_accessor :id, :options, :client

    def initialize(client, options={})
      response = self.class.create(client, options)
      @client = client
    end
    
    # Instance Methods
    
    def add(options={})
      self.class.add_symbol(@client, id, options={})
    end
    
    def delete(symbol)
      self.class.delete_symbol(@client, id, symbol)
    end
    
    # Class Methods
    
    def self.list(client)
      return client.get('/v1/watchlists.json')["watchlists"].map do | watchlist |
        self.class.show(client, watchlist['watchlist']['id'])
      end
    end
    
    def self.create(client, options={})
      raise ArgumentError, "You must supply a watchlist id" unless options[:id]
      options[:id] = options[:id].to_slug
      @id = optios[:id]
      params = options.filter([:id,:symbols]).to_params
      return client.post("/v1/watchlists.json?#{params}")
    end
    
    def self.show(client, id)
      raise ArgumentError, "You must supply a watchlist id" unless id
      return client.get("/v1/watchlists/#{id}.json")
    end
    
    def self.delete(client, id)
      raise ArgumentError, "You must supply a watchlist id" unless id
      return client.delete("/v1/watchlists/#{id}.json")
    end

    def add_symbol(client, id, options={})
      raise ArgumentError, "You must supply an array of symbols" unless options[:symbols] && options[:symbols].is_a?(Array)
      params = options.filter([:symbols]).to_params
      return client.post("/v1/watchlists/#{id}/symbols.json?#{params}")
    end
    
    def delete_symbol(client, id, symbol)
      raise ArgumentError, "You must supply a symbol" unless symbol
      return client.delete("/v1/watchlists/#{id}/symbols/#{symbol}.json?#{params}")
    end
  end
end