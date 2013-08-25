module TradeKing
  class Article

    def fields
      ['id', 'headline', 'date', 'story']
    end
  
    def self.search(options={})
      puts "search"
      client = options.delete(:client)
      url = "market/news/search"
      p =self.params(options[:args][0])
      request = TradeKing::Request.new(resource: TradeKing::Option, client: client, path: '')
      request.collection_from_response(:get, url, p)
    end
  
    def self.params(options={})
      params = {}
      [:keywords, :symbols, :maxhits, :limit, :startdate, :enddate].each do |sym|
        params[sym] = options[sym] if options[sym].present?
      end
      return params
    end
  end
end
