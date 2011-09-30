# encoding: utf-8

require 'faraday'

module Github
  module Request
    class OAuth2 < Faraday::Middleware
      dependency 'oauth2'

      def call(env)
        puts env.inspect
        puts "TOKEN : #{@token}"
        puts "APP: #{@app}"
        
        # Extract parameters from the query
        params = env[:url].query_values || {}
        
        env[:url].query_values = { 'access_token' => @token }.merge(params)

        token = env[:url].query_values['access_token']

        env[:request_headers].merge!('Authorization' => "Token token=\"#{token}\"")

        @app.call env
      end
      
      def initialize(app, *args)
        @app = app
        @token = args.shift
      end
    end
  end
end # Github
