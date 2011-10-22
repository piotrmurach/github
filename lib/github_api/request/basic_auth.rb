# encoding: utf-8

require 'faraday'
require 'base64'

module Github
  module Request
    class BasicAuth < Faraday::Middleware
      dependency 'base64'

      def call(env)
        # puts "BASIC: #{@auth}"
        env[:request_headers].merge!('Authorization' => "Basic #{@auth}\"")

        @app.call env
      end

      def initialize(app, *args)
        @app = app
        login, password = args.shift, args.shift
        @auth = Base64.encode64("#{login}:#{password}")
        @auth.gsub!("\n", "")
      end
    end # BasicAuth
  end # Request
end # Github
