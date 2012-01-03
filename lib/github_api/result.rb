# encoding: utf-8

module Github
  module Result

    RATELIMIT_REMAINING = 'X-RateLimit-Remaining'.freeze
    RATELIMIT_LIMIT = 'X-RateLimit-Limit'.freeze
    CONTENT_TYPE = 'Content-Type'.freeze
    CONTENT_LENGTH = 'content-length'.freeze

    attr_reader :env

    # Requests are limited to API v3 to 5000 per hour.
    def ratelimit_limit
      loaded? ? @env[:response_headers][RATELIMIT_LIMIT] : nil
    end

    def ratelimit_remaining
      loaded? ? @env[:response_headers][RATELIMIT_REMAINING] : nil
    end

    def content_type
      loaded? ? @env[:response_headers][CONTENT_TYPE] : nil
    end

    def content_length
      loaded? ? @env[:response_headers][CONTENT_LENGTH] : nil
    end

    def status
      loaded? ? @env[:status] : nil
    end

    def success?
      (200..299).include? status
    end

    def body
      loaded? ? @env[:body] : nil
    end

    def loaded?
      !!env
    end

  end # Result
end # Github
