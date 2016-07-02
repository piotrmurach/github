# encoding: utf-8

require 'json'

module Github
  # Raised when GitHub returns any of the HTTP status codes
  module Error
    class ServiceError < GithubError
      # Add http status code method to error type
      #
      # @param [Integer] code
      #   the status code
      #
      # @api public
      def self.http_status_code(code)
        define_method(:http_status_code) { code }
      end

      # A mapping of status codes and error types
      #
      # @return [Hash[Integer, Object]]
      #
      # @api public
      def self.errors
        @errors ||= Hash[
          descendants.map { |klass| [klass.new({}).http_status_code, klass] }
        ]
      end

      MIN_BODY_LENGTH = 2

      # Crate a ServiceError
      #
      # @param [Hash[Symbol]] response
      #
      # @api public
      def initialize(response)
        @headers = response[:response_headers]
        @body    = response[:body]
        @status  = response[:status]

        super(create_message(response))
      end

      private

      # Create full error message
      #
      # @param [Hash[Symbol]] response
      #   the http response
      #
      # @return [String]
      #   the error message
      #
      # @api private
      def create_message(response)
        return if response.nil?

        message = "#{response[:method].to_s.upcase} "
        message << "#{response[:url]}: "
        message << "#{@status} - #{parse_body(@body)}"
        message
      end

      # Decode body information if in JSON format
      #
      # @param [String] body
      #   the response body
      #
      # @api private
      def decode_data(body)
        if body.respond_to?(:to_str) &&
           body.length >= MIN_BODY_LENGTH &&
           @headers[:content_type] =~ /json/

          JSON.parse(body, symbolize_names: true)
        else
          body
        end
      end

      # @api private
      def parse_body(body)
        data = decode_data(body)

        return '' if data.nil? || data.empty?

        case data
        when Hash
          message = data[:message] ? data[:message] : ' '
          docs = data[:documentation_url]
          error = create_error_summary(data)
          message << error if error
          message << "\nSee: #{docs}" if docs
          message
        when String
          data
        end
      end

      # Create error summary from response body
      #
      # @return [String]
      #
      # @api private
      def create_error_summary(data)
        if data[:error]
          return "\nError: #{data[:error]}"
        elsif data[:errors]
          message = "\nErrors:\n"
          message << data[:errors].map do |error|
            "Error: #{error.map {|key, val| "#{key}: #{val}"}.join(', ')}"
          end.join("\n")
        end
      end
    end # ServiceError
  end # Error
end # Github
