module TradeKing
  class Client

    require 'oauth'
    require 'rest-client'
    require 'json'
    require 'active_support/core_ext/string'
    require "active_support/core_ext/numeric/time"

    attr_accessor :request_params, :base_uri, :consumer_key, :consumer_secret, :oauth_token, :oauth_secret, :request_path

    API_VERSION = "1"
    DEFAULT_BASE_URI = "https://api.tradeking.com"

    class << self
      attr_accessor :api_base_uri, :consumer_key, :consumer_secret, :oauth_token, :oauth_secret, :request_path

      def configure
        yield self
        self
      end
    end

    def initialize(opts={})
      @base_uri = opts[:base_uri] || config_base_uri
      @consumer_key = opts[:consumer_key] || config_consumer_key
      @consumer_secret = opts[:consumer_secret] || config_consumer_secret
      @request_params = opts[:request_params] || {}
      @request_path = []

      raise ArgumentError, "You must have a valid consumer_key and consumer_secret" unless @consumer_key.present? && @consumer_secret.present?
      get_consumer(@consumer_key, @consumer_secret)
      authorize(opts) if opts[:oauth_token] && opts[:oauth_secret]
    end
    
    def authorize(opts={})
      @oauth_token = opts[:oauth_token] || config_oauth_token
      @oauth_secret = opts[:oauth_secret] || config_oauth_secret
      get_oauth_token(@oauth_token, @oauth_secret) if @oauth_token && @oauth_secret
    end

    def default_options
      {
        :timestamp => synchronized_time,
        :site => @base_uri
      }
    end

    def config_base_uri
      self.class.api_base_uri || DEFAULT_BASE_URI
    end

    def config_consumer_key
      self.class.consumer_key || ENV['TRADEKING_CONSUMER_KEY']
    end
    
    def config_consumer_secret
      self.class.consumer_secret || ENV['TRADEKING_CONSUMER_SECRET']
    end
    
    def config_oauth_token
      self.class.oauth_token || ENV['TRADEKING_OAUTH_TOKEN']
    end
    
    def config_oauth_secret
      self.class.oauth_secret || ENV['TRADEKING_OAUTH_SECRET']
    end

    # Perform an HTTP GET request
    def get(path, params={})
      perform(:get, path, params)
    end
    
    # Perform an HTTP PUT request
    def put(path, params={})
      perform(:put, path, params)
    end
    
    # Perform an HTTP DELETE request
    def post(path, params={})
      perform(:post, path, params)
    end
    
    # Perform an HTTP DELETE request
    def delete(path, params={})
      perform(:delete, path, params)
    end

    def resource(name)
      klass_string = "TradeKing::#{name.to_s.singularize.classify}"
      klass_string.constantize rescue name
    end

    def method_missing(method, *args, &block)
      TradeKing::Request.new(resource: resource(method), client: self)
    end

    private
    
    def synchronized_time
      # Important! Must be within 10 seconds of API clock at time of request.
      # Thier clock is 5 minutes and 19 seconds behind utc.
      (Time.now - 5.minutes - 19.seconds).in_time_zone(-5).to_i.to_s
    end

    def get_consumer(consumer_key, consumer_secret, options={})
      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, options.merge!(default_options))
      self.class.__send__(:attr_accessor, :consumer)
      self.instance_variable_set("@consumer", consumer)
      return consumer
    end
    
    def get_oauth_token(oauth_token=nil,oauth_secret=nil)
      token = OAuth::AccessToken.new(@consumer,oauth_token,oauth_secret) if oauth_token && oauth_secret
      self.class.__send__(:attr_accessor, :token)
      self.instance_variable_set("@token", token)
      return token
      raise ArgumentError, "You must have a valid token and secret"
    end
    
    def get_request_token(oauth_token=nil,oauth_secret=nil)
      return OAuth::RequestToken.new(get_consumer, oauth_token, oauth_secret) if oauth_token && oauth_secret
      raise ArgumentError, "You must have a valid token and secret"
    end

    def perform(method, url, params={})
      url = "/v#{API_VERSION}/#{url}.json"
      token.consumer.options[:timestamp] = synchronized_time
      response = token.send(method, url, params)
      raise ArgumentError, "Invalid Request" unless response.code == '200'
      response = JSON.parse(response.body)["response"]
      raise ArgumentError, "#{response["name"]}:: #{response["description"]}" if response["type"]=="Error"
      return response
    end
  end
end