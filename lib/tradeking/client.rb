module TradeKing
  class Client

    require 'oauth'
    require 'rest-client'
    require 'json'
    require 'active_support/core_ext/string'
    require "active_support/core_ext/numeric/time"
    # require 'em-http'
    # require 'em-http/middleware/oauth'
    # require 'em-http/middleware/json_response'
    # require 'pp'
    # require 'yajl/http_stream'
    # require 'simple_oauth'
    
    attr_accessor :request_params, :base_uri, :consumer_key, :consumer_secret, :access_token, :access_token_secret, :request_path, :discrepancy_in_seconds

    API_VERSION = "1"
    DEFAULT_BASE_URI = "https://api.tradeking.com"
    $seconds_offset=0
    
    class << self
      attr_accessor :api_base_uri, :consumer_key, :consumer_secret, :access_token, :access_token_secret, :request_path

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
      authorize(opts) if opts[:access_token] && opts[:access_token_secret]
    end
    
    def authorize(opts={})
      @access_token = opts[:access_token] || config_access_token
      @access_token_secret = opts[:access_token_secret] || config_access_token_secret
      get_access_token(@access_token, @access_token_secret) if @access_token && @access_token_secret
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
    
    def config_access_token
      self.class.access_token || ENV['TRADEKING_OAUTH_TOKEN']
    end
    
    def config_access_token_secret
      self.class.access_token_secret || ENV['TRADEKING_OAUTH_SECRET']
    end
    
    def oauth_config
      {
        :consumer_key     => consumer_key,
        :consumer_secret  => consumer_secret,
        :access_token     => access_token,
        :access_token_secret => access_token_secret
      }
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

    def stream(url, params={})
      params = params.to_params
      url = [url, params].join("?")
      puts url.inspect
      EM.run do
        conn = EventMachine::HttpRequest.new(url)
        conn.use EventMachine::Middleware::OAuth, oauth_config

         http = conn.get
         http.stream { |chunk| puts chunk }

         http.errback do
           puts "error back"
           EM.stop
         end

         trap("INT")  { http.close; EM.stop }
         trap("TERM") { http.close; EM.stop }
       end
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
      (Time.now - $seconds_offset.seconds).in_time_zone(-5).to_i.to_s
    end

    def get_consumer(consumer_key, consumer_secret, options={})
      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, options.merge!(default_options))
      self.class.__send__(:attr_accessor, :consumer)
      self.instance_variable_set("@consumer", consumer)
      return consumer
    end
    
    def get_access_token(access_token=nil,access_token_secret=nil)
      token = OAuth::AccessToken.new(@consumer,access_token,access_token_secret) if access_token && access_token_secret
      self.class.__send__(:attr_accessor, :token)
      self.instance_variable_set("@token", token)
      $seconds_offset = (Time.now.in_time_zone(-5).to_i - market.clock["unixtime"].to_i) if !!($seconds_offset==0)
      return token
      raise ArgumentError, "You must have a valid token and secret"
    end
    
    def get_request_token(access_token=nil,access_token_secret=nil)
      return OAuth::RequestToken.new(get_consumer, access_token, access_token_secret) if access_token && access_token_secret
      raise ArgumentError, "You must have a valid token and secret"
    end

    def perform(method, url, params={})
      url = "/v#{API_VERSION}/#{url}.json"
      token.consumer.options[:timestamp] = synchronized_time
      if method.to_s == 'get' && !params.empty?; url = url+"?#{params.to_params}"; params = {}; end
      response = token.send(method, url, params)
      raise ArgumentError, "Invalid Request" unless response.code == '200'
      response = JSON.parse(response.body)["response"]
      raise ArgumentError, "#{response["name"]}:: #{response["description"]}" if response["type"]=="Error"
      return response
    end
  end
end