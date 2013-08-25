module TradeKing
  class Timesale < Collection

    def fields
      ['date','datetime','hi','incr_vl','last','lo','opn', 'timestamp', 'vl']
    end
  end
end