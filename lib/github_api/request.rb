# encoding: utf-8

module Github

  # Defines HTTP verbs
  module Request

    METHODS = [:get, :post, :put, :delete, :patch]
    METHODS_WITH_BODIES = [ :post, :put, :patch ]

    def get_request(path, params={})
      request(:get, path, params).auto_paginate
    end

    def patch_request(path, params={})
      request(:patch, path, params)
    end

    def post_request(path, params={})
      request(:post, path, params)
    end

    def put_request(path, params={})
      request(:put, path, params)
    end

    def delete_request(path, params={})
      request(:delete, path, params)
    end

    def request(method, path, params) # :nodoc:
      if !METHODS.include?(method)
        raise ArgumentError, "unkown http method: #{method}"
      end

      puts "EXECUTED: #{method} - #{path} with PARAMS: #{params}" if ENV['DEBUG']

      conn_options = params.options.merge(current_options)
      conn = connection(conn_options)
      if conn.path_prefix != '/' && path.index(conn.path_prefix) != 0
        path = (conn.path_prefix + path).gsub(/\/(\/)*/, '/')
      end

      response = conn.send(method) do |request|
        case method.to_sym
        when *(METHODS - METHODS_WITH_BODIES)
          request.body = params.data if params.has_key?('data')
          request.url(path, params.to_hash)
        when *METHODS_WITH_BODIES
          request.path = path
          request.body = params.data unless params.empty?
        end
      end
      ResponseWrapper.new(response, self)
    end

  end # Request
end # Github
