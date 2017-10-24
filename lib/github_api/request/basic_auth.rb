# encoding: utf-8

require 'faraday'
require 'base64'

module Github
  class Request
    class BasicAuth < Faraday::Middleware
      dependency 'base64'

      # @api private
      def initialize(app, *args)
        @app    = app
        @auth   = nil
        options = args.extract_options!

        if options.key?(:login) && !options[:login].nil?
          credentials = "#{options[:login]}:#{options[:password]}"
          @auth = Base64.encode64(credentials)
          @auth.gsub!("\n", "")
        end
      end

      # Update request headers
      #
      # @api private
      def call(env)
        if @auth
          env[:request_headers].merge!('Authorization' => "Basic #{@auth}\"")
        end

        @app.call(env)
      end
    end # BasicAuth
  end # Request
end # Github
