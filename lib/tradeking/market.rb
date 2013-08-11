module TradeKing
  class Market #< Request

    PATH = "market"

    attr_accessor :id, :options, :client, :path

    def self.clock(options={})
      options[:client].get("market/clock", {})
    end
  end
end