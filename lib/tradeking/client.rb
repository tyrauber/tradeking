module TradeKing
  class Client

    require 'rest-client'
    require 'json'
    require 'oauth'
    
    attr_reader :watchlists
    
    def default_urls
      {
        :site               => 'https://api.tradeking.com',
        :authorize_url      => 'https://developers.tradeking.com/oauth/authorize',
        :request_token_url  => 'https://developers.tradeking.com/oauth/request_token',
        :access_token_url   => 'https://developers.tradeking.com/oauth/access_token'
      }
    end
    
    def initialize(options = {})
      update(options)
    end
    
    def update(options = {})
      
      ## Parse options to create instance variables with TradeKing tokens and secrets
      [:consumer_token, :consumer_secret, :access_token, :access_secret].each do | key |
        self.class.__send__(:attr_accessor, key)
        instance_variable_set("@#{key.to_s}", options[key]) unless options[key].nil?
      end
      raise ArgumentError, "You must have a valid consumer_token and consumer_secret" unless consumer_token && consumer_secret

      # Create consumer and access tokens to make requests to TradeKing
      get_consumer(consumer_token, consumer_secret)
      get_access_token(access_token, access_secret) if access_token && access_secret
      
      
      # Establish instance class relationships
      @watchlists = TradeKing::Watchlist.list(self)
      
      return self
    end
    
    def get(url)
      return Request.new(self, url, "get")
    end
    
    def delete(url)
      return Request.new(self, url, "delete")
    end
    
    def post(url)
      return Request.new(self, url, "post")
    end
    
    private
    
    def get_consumer(consumer_key, consumer_secret, options={})
      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, options = {:site => default_urls[:site]})
      self.class.__send__(:attr_accessor, :consumer)
      self.instance_variable_set("@consumer", consumer)
      return consumer
    end
    
    def get_access_token(access_token=nil,access_secret=nil)
      token = OAuth::AccessToken.new(@consumer,access_token,access_secret) if access_token && access_secret
      self.class.__send__(:attr_accessor, :token)
      self.instance_variable_set("@token", token)
      return token
      raise ArgumentError, "You must have a valid token and secret"
    end
    
    def get_request_token(access_token=nil,access_secret=nil)
      return OAuth::RequestToken.new(get_consumer,token,secret) if access_token && access_secret
      raise ArgumentError, "You must have a valid token and secret"
    end
  end
end
class String
  def to_slug
    downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
end
class Hash
  def filter(keys)
    select { |key, value| keys.include? key }
  end
  def to_params
    self.map{|k,v| "#{k.to_s}=#{ v.is_a?(Array) ? v.join(",") : v.is_a?(Hash) ? v.to_params.join("&") : v.to_s }" }.join("&")
  end
end