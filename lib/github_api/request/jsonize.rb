# encoding: utf-8

require 'faraday'

module Github
  class Request::Jsonize < Faraday::Middleware

    CONTENT_TYPE = 'Content-Type'.freeze
    MIME_TYPE    = 'application/json'.freeze

    dependency 'multi_json'

    def call(env)
      if request_with_body?(env)
        env[:request_headers][CONTENT_TYPE] ||= MIME_TYPE
        env[:body] = encode_body env[:body] unless env[:body].respond_to?(:to_str)
      elsif safe_to_modify?(env)
        # Ensure valid body for put and post requests
        if [:put, :patch, :post].include?(env[:method])
          env[:body] = encode_body({})
        end
      end
      @app.call env
    end

    def encode_body(value)
      if MultiJson.respond_to?(:dump)
        MultiJson.dump(value)
      else
        MultiJson.encode(value)
      end
    end

    def request_with_body?(env)
      type = request_type(env)
      has_body?(env) and safe_to_modify?(env)
    end

    def safe_to_modify?(env)
      type = request_type(env)
      type.empty? or type == MIME_TYPE
    end

    # Don't encode bodies in string form
    def has_body?(env)
      body = env[:body] and !(body.respond_to?(:to_str) and body.empty?)
    end

    def request_type(env)
      type = env[:request_headers][CONTENT_TYPE].to_s
      type = type.split(';', 2).first if type.index(';')
      type
    end
  end # Request::Jsonize
end # Github
