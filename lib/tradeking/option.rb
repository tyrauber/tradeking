module TradeKing
  class Option < Collection
    
    def fields
      ["symbol", "dates", "strikes", "ask", "ask_time", "asksz", "basis", "bid", "bid_time", "bidsz", "chg", "chg_sign", "chg_t", "cl", "contract_size", "date", "datetime", "days_to_expiration", "exch", "exch_desc", "hi", "igamma", "imp_volatility", "incr_vl", "irho", "issue_desc", "itheta", "ivega", "last", "lo", "op_delivery", "op_flag", "op_style", "op_subclass", "opn", "opt_val", "pchg", "pchg_sign", "pcls", "phi", "plo", "popn", "pr_openinterest", "prchg", "prem_mult", "put_call", "pvol", "qcond", "rootsymbol", "secclass", "sesn", "strikeprice", "symbol", "tcond", "timestamp", "tr_num", "tradetick", "under_cusip", "undersymbol", "vl", "vwap", "xdate", "xday", "xmonth", "xyear"] 
    end
    
    def self.path
      "market/options"
    end

    def self.parse_collection(options={})
      return options['quotes']['quote'] if options['quotes'].present?
    end

    def self.search(options={})
      client = options.delete(:client)
      url = "market/options/search"
      o = options[:args][0]
      params = {symbol: o[:symbol]}
      params.merge!({query: o[:query]})
      request = TradeKing::Request.new(resource: TradeKing::Option, client: client, path: '')
      request.collection_from_response(:post, url, params)
    end
    
    def self.expirations(options={})
      client = options.delete(:client)
      url = "market/options/expirations"
      symbol = options[:args][0]
      params = {symbol: symbol}
      response = client.send(:get, url, params)
      self.new({'symbol' => symbol, 'dates' => response['expirationdates']['date']})
    end

    def self.strikes(options={})
      client = options.delete(:client)
      url = "market/options/strikes"
      symbol = options[:args][0]
      params = {symbol: symbol}
      response = client.send(:get, url, params)
      self.new({'symbol' => symbol, 'strikes' => response['prices']['price']})
    end
  end
end
