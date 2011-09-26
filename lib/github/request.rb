module Github
  # Defines HTTP verbs
  module Request
    
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    def patch(path, params={}, options={})
      request(:patch, path, params, options)
    end

    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

    def put(path, params={}, options={})
      request(:put, path, params, options)
    end

    def delete(path, params={}, options={})
      request(:delete, path, params, options)
    end

    private

    def request(method, path, params, options)

    end
  end # Request
end # Github
