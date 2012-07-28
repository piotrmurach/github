# encoding: utf-8
require 'multi_json'

module Github
  # Raised when GitHub returns any of the HTTP status codes
  module Error
    class ServiceError < GithubError
      attr_reader :http_headers

      def initialize(response)
        @http_headers = response[:response_headers]
        message = parse_response(response)
        super(message)
      end

      def parse_response(response)
        body = parse_body(response[:body])
        "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]} #{body}"
      end

      def decode_body(body)
        if body.respond_to?(:to_str) && body.length >= 2
           MultiJson.load(body, :symbolize_keys => true)
        else
          body
        end
      end

      def parse_body(body)
        body = decode_body(body)

        return '' if body.nil? || body.empty?

        if body[:error]
          body[:error]
        elsif body[:errors]
          error = Array(body[:errors]).first
          if error.kind_of?(Hash)
            error[:message]
          else
            error
          end
        elsif body[:message]
          body[:message]
        else
          ''
        end
      end

      def self.http_status_code(code)
        define_method(:http_status_code) { code }
      end

    end
  end # Error
end # Github
