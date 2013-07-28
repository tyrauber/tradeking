module TradeKing
  class Request

    require 'rest-client'
    require 'json'
    require 'oauth'

    def initialize(client, url, method="get")
      response = client.token.send(method, url, {'Accept' => 'application/json'})
      return self.class.parse(response)
    end
    
    private
     
    def self.parse(response)
      raise ArgumentError, "Invalid Request" unless response.code == '200'
      response = JSON.parse(response.body)["response"]
      raise ArgumentError, "#{response["name"]}:: #{response["description"]}" if response["type"]=="Error"
      return response
    end
  end
end