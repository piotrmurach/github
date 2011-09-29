# encoding: utf-8

require 'base64'
require 'addressable/uri'
require 'set'

module Github
  # Defines HTTP verbs
  module Request
    
    METHODS = [:get, :post, :put, :delete, :patch]
    METHODS_WITH_BODIES = [ :post, :put, :patch ]

    TOKEN_REQUIRED_REGEXP = [
      /repos\/.*\/.*\/comments/,
    ]

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

    def request(method, path, params, options)
      if !METHODS.include?(method)
        raise ArgumentError, "unkown http method: #{method}"
      end

      puts "EXECUTED: #{method} - #{path} with #{params} and #{options}"
      
      response = connection(options).send(method) do |request|
        case method.to_sym
        when *(METHODS - METHODS_WITH_BODIES)
          request.url(path, params)          
        when *METHODS_WITH_BODIES
          request.path = path
          request.body = params unless params.empty?
        end
      end
      response.body
    end
    
    # no need for this smizzle
    def formatted_path(path, options={})
      [ path, options.fetch(:format, format) ].compact.join('.')
    end

    def basic_auth(login, password)
      auth = Base64.encode("#{login}:#{password}")
      auth.gsub!("\n", "")
    end

    def token_auth
    end

  end # Request
end # Github
