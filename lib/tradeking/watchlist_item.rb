module TradeKing
  class WatchlistItem
    attr_accessor :costbasis, :qty, :instrument, :symbol

    def initialize(options={})
      @id = options['id']
      @costbasis = options['costbasis'].to_f
      @qty = options['qty'].to_f
      @symbol = options['instrument']['sym']
      #@instrument = TradeKing::Instrument.new({symbol: options['sym']})
    end
  end
end