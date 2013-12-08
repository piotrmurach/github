# encoding: utf-8
# require 'multi_json'
require 'github_api/jsonable'

module Github
  # Raised when GitHub returns any of the HTTP status codes
  module Error
    class ServiceError < GithubError
      include ::Github::Jsonable

      attr_reader :http_headers, :body, :status

      MIN_BODY_LENGTH = 2

      def initialize(response)
        @http_headers = response[:response_headers]
        message       = parse_response(response)
        super(message)
      end

      def parse_response(response)
        @body   = parse_body(response[:body])
        @status = response[:status]
        "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{@status} #{@body}"
      end

      def decode_body(body)
        if body.respond_to?(:to_str) && body.length >= MIN_BODY_LENGTH
           decode body, symbolize_keys: true
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

      def self.errors
        @errors ||= Hash[
          descendants.map { |klass| [klass.new({}).http_status_code, klass] }
        ]
      end

    end
  end # Error
end # Github
