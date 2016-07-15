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
      def self.error_mapping
        @error_mapping ||= Hash[
          descendants.map do |klass|
            [klass.new({}).http_status_code, klass]
          end
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

        @response_headers = @headers
        @response_message = @body

        super(create_message(response))
      end

      # Expose response payload as JSON object if possible
      #
      # @return [Hash[Symbol]|String]
      #
      # @api public
      def data
        @data ||= decode_data(@body)
      end

      # Stores error message(s) returned in response body
      #
      # @return [Array[Hash[Symbol]]]
      #   the array of hash error objects
      #
      # @api public
      def error_messages
        @error_messages ||= begin
          data[:errors] ? data[:errors] : [data]
        end
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
        message << "#{@status} - #{format_response}"
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

      # Read response body and convert to human friendly format
      #
      # @return [String]
      #
      # @api private
      def format_response
        return '' if data.nil? || data.empty?

        case data
        when Hash
          message = data[:message] ? data[:message] : ' '
          docs = data[:documentation_url]
          error = create_error_summary
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
      def create_error_summary
        if data[:error]
          "\nError: #{data[:error]}"
        elsif data[:errors]
          message = "\nErrors:\n"
          message << data[:errors].map do |error|
            "Error: #{error.map { |k, v| "#{k}: #{v}" }.join(', ')}"
          end.join("\n")
        end
      end
    end # ServiceError

    # Raised when Github returns the HTTP status code 400
    class BadRequest < ServiceError
      http_status_code 400
    end

    # Raised when GitHub returns the HTTP status code 401
    class Unauthorized < ServiceError
      http_status_code 401
    end

    # Raised when Github returns the HTTP status code 403
    class Forbidden < ServiceError
      http_status_code 403
    end

    # Raised when Github returns the HTTP status code 404
    class NotFound < ServiceError
      http_status_code 404
    end

    # Raised when Github returns the HTTP status code 405
    class MethodNotAllowed < ServiceError
      http_status_code 405
    end

    # Raised when Github returns the HTTP status code 406
    class NotAcceptable < ServiceError
      http_status_code 406
    end

    # Raised when GitHub returns the HTTP status code 409
    class Conflict < ServiceError
      http_status_code 409
    end

    # Raised when GitHub returns the HTTP status code 414
    class UnsupportedMediaType < ServiceError
      http_status_code 414
    end

    # Raised when GitHub returns the HTTP status code 422
    class UnprocessableEntity < ServiceError
      http_status_code 422
    end

    # Raised when GitHub returns the HTTP status code 451
    class UnavailableForLegalReasons < ServiceError
      http_status_code 451
    end

    # Raised when Github returns the HTTP status code 500
    class InternalServerError < ServiceError
      http_status_code 500
    end

    # Raised when Github returns the HTTP status code 501
    class NotImplemented < ServiceError
      http_status_code 501
    end

    # Raised when Github returns the HTTP status code 502
    class BadGateway < ServiceError
      http_status_code 502
    end

    # Raised when GitHub returns the HTTP status code 503
    class ServiceUnavailable < ServiceError
      http_status_code 503
    end
  end # Error
end # Github
