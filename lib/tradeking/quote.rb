module TradeKing
  class Quote < Collection
    
    def fields
      ["adp_100", "adp_200", "adp_50", "adv_21", "adv_30", "adv_90", "ask", "ask_time", "asksz", "basis", "beta", "bid", "bid_time", "bidsz", "bidtick", "chg", "chg_sign", "chg_t", "cl", "cusip", "date", "datetime", "div", "divexdate", "dollar_value", "eps", "exch", "exch_desc", "hi", "iad", "incr_vl", "last", "lo", "name", "op_flag", "opn", "pchg", "pchg_sign", "pcls", "pe", "phi", "plo", "popn", "pr_adp_100", "pr_adp_200", "pr_adp_50", "pr_date", "prbook", "prchg", "pvol", "qcond", "secclass", "sesn", "sesn_vl", "sho", "symbol", "tcond", "timestamp", "tr_num", "tradetick", "trend", "vl", "volatility12", "vwap", "wk52hi", "wk52hidate", "wk52lo", "wk52lodate"]
    end

    def self.parse_collection(options={})
      [options['quotes']['quote']]
    end
  end
end
