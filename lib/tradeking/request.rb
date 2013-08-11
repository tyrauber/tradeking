module TradeKing
  class Request

    attr_accessor :client, :resource

    def initialize(opts={})
      @resource = opts[:resource] || self.class
      @path =   opts[:path] || @resource::PATH
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

    def object_from_response(method, url, params={})
      response = client.send(method, url, params)
      response = resource.parse_object(response) if resource.respond_to?(:parse_object)
      resource.new(response.merge!({'client' => client}))
    end

    def collection_from_response(method, url, params={})
      collection =[]
      response = client.send(method, url, params)
      response = resource.parse_collection(response) if resource.respond_to?(:parse_collection)
      response.each do |r|
        collection.push resource.new(r.merge!({'client' => client}))
      end
      return collection
    end

    def method_missing(method, *args, &block)
      @resource.send(method, {:args => args, :client => @client})
    end

  end
end