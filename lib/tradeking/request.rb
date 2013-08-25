module TradeKing
  class Request

    attr_accessor :client, :resource

    def initialize(opts={})
      @resource = opts[:resource] || self.class
      @path =   @resource.respond_to?(:path) ? @resource.path : opts[:path]
      @client = opts[:client]
    end

    # Get request on resource#create
    def create(params={})
      collection_from_response(:post, @path, params)
    end
    
    # Get request on resource#show
    def find(id, params={})
      @request_path = [@path, CGI::escape(id.to_s)]
      @resource.request_path = @request_path if @resource.respond_to?(:request_path)
      object_from_response(:get, @request_path.join('/'), params={})
    end

    # Get request on resource#index with query params
    def where(params={})
      #collection_from_response(:get, path, params)
      collection_from_response(:get, @path, params={})
    end

    # Convenience Method
    def all
      where({})
    end

    def delete(id, params={})
      @request_path = [@path, CGI::escape(id.to_s)]
      object_from_response(:delete, @request_path.join('/'), params={})
    end

    def destroy
      delete(id, params={})
    end
    
    # def stream(url, params={})
    #   #@request_path = [url, "?", params.to_params]
    #   stream_response(url, params={})
    # end

    def object_from_response(method, url, params={})
      response = client.send(method, url, params)
      response = resource.parse_object(response) if resource.respond_to?(:parse_object)
      resource.new(response.merge!({'client' => client}))
    end

    def collection_from_response(method, url, params={})
      collection =[]
      response = client.send(method, url, params)
      response = resource.parse_collection(response) if resource.respond_to?(:parse_collection)
      puts response.inspect
      response.each do |r|
        r.merge!({'client' => client}) if r.is_a?(Hash)
        collection.push resource.new(r)
      end
      return collection
    end

    def method_missing(method, *args, &block)
      @resource.send(method, {:args => args, :client => @client})
    end

    # 
    # def stream_response(url, params={})
    #   puts self.inspect
    #   puts "#{url}#{params.to_params}"
    #   puts client.inspect
    #   # oauth={
    #   #   
    #   # }
    #   # EM.run do
    #   #   EventMachine::HttpRequest.use EventMachine::Middleware::JSONResponse
    #   #   conn = EventMachine::HttpRequest.new(url+params.to_params)
    #   #   conn.use EventMachine::Middleware::OAuth, OAuthConfig
    #   # 
    #   #   http = conn.get
    #   #   http.callback do
    #   #     pp http.response
    #   #     EM.stop
    #   #   end
    #   # 
    #   #   http.errback do
    #   #     puts "Failed retrieving user stream."
    #   #     pp http.response
    #   #     EM.stop
    #   #   end
    #   # end
    # end
  end
end