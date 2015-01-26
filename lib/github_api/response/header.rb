# encoding: utf-8

module Github
  class Response

    # Represents http response header
    class Header < Struct.new(:env)
      include Github::Constants

      SUCCESSFUL_STATUSES = 200..299

      def loaded?
        !!env
      end

      def oauth_scopes
        loaded? ? env[:response_headers][OAUTH_SCOPES] : nil
      end

      def accepted_oauth_scopes
        loaded? ? env[:response_headers][ACCEPTED_OAUTH_SCOPES] : nil
      end

      # Requests are limited to API v3 to 5000 per hour.
      def ratelimit_limit
        loaded? ? env[:response_headers][RATELIMIT_LIMIT] : nil
      end

      def ratelimit_remaining
        loaded? ? env[:response_headers][RATELIMIT_REMAINING] : nil
      end

      # A unix timestamp describing when the ratelimit will
      # be reset
      def ratelimit_reset
        loaded? ? env[:response_headers][RATELIMIT_RESET] : nil
      end

      def cache_control
        loaded? ? env[:response_headers][CACHE_CONTROL] : nil
      end

      def content_type
        loaded? ? env[:response_headers][CONTENT_TYPE] : nil
      end

      def content_length
        loaded? ? env[:response_headers][CONTENT_LENGTH] : nil
      end

      def etag
        loaded? ? env[:response_headers][ETAG] : nil
      end

      def date
        loaded? ? env[:response_headers][DATE] : nil
      end

      def location
        loaded? ? env[:response_headers][LOCATION] : nil
      end

      def server
        loaded? ? env[:response_headers][SERVER] : nil
      end

      def status
        loaded? ? env[:status] : nil
      end

      def success?
        SUCCESSFUL_STATUSES.include? status
      end

      # Returns raw body
      def body
        loaded? ? env[:body] : nil
      end

    end # Header
  end # Response
end # Github
