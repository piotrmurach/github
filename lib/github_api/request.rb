# encoding: utf-8

module Github

  # Defines HTTP verbs
  module Request

    METHODS = [:get, :post, :put, :delete, :patch]

    METHODS_WITH_BODIES = [:post, :put, :patch]

    def get_request(path, params = ParamsHash.empty)
      request(:get, path, params).auto_paginate
    end

    def patch_request(path, params = ParamsHash.empty)
      request(:patch, path, params)
    end

    def post_request(path, params = ParamsHash.empty)
      request(:post, path, params)
    end

    def put_request(path, params = ParamsHash.empty)
      request(:put, path, params)
    end

    def delete_request(path, params = ParamsHash.empty)
      request(:delete, path, params)
    end

    # Performs a request
    #
    # method - The Symbol the HTTP verb
    # path   - String relative URL to access
    # params - ParamsHash to configure the request API
    #
    # Returns a Github::ResponseWrapper
    #
    def request(method, path, params) # :nodoc:
      unless METHODS.include?(method)
        raise ArgumentError, "unkown http method: #{method}"
      end

      puts "EXECUTED: #{method} - #{path} with PARAMS: #{params}" if ENV['DEBUG']

      request_options    = params.options
      connection_options = current_options.merge(request_options)
      conn               = connection(connection_options)

      if conn.path_prefix != '/' && path.index(conn.path_prefix) != 0
        path = (conn.path_prefix + path).gsub(/\/(\/)*/, '/')
      end

      response = conn.send(method) do |request|
        case method.to_sym
        when *(METHODS - METHODS_WITH_BODIES)
          request.body = params.data if params.has_key?('data')
          if params.has_key?('encoder')
            request.params.params_encoder(params.encoder)
          end
          request.url(path, params.to_hash)
        when *METHODS_WITH_BODIES
          request.url(path, connection_options[:query] || {})
          request.body = params.data unless params.empty?
        end
      end
      ResponseWrapper.new(response, self)
    end

  end # Request
end # Github
