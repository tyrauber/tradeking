module TradeKing
  class Toplist < Collection

    def fields
      ['chg', 'last', 'name', 'pchg', 'pcls', 'rank', 'symbol', 'vl']
    end
  end
end