# encoding: utf-8

module Github
  module Result

    RATELIMIT = 'X-RateLimit-Remaining'.freeze
    CONTENT_TYPE = 'Content-Type'.freeze
    CONTENT_LENGTH = 'content-length'.freeze

    attr_reader :env

    # Requests are limited to API v3 to 5000 per hour.
    def ratelimit
      @env[:response_headers][RATELIMIT]
    end

    def content_type
      @env[:response_headers][CONTENT_TYPE]
    end

    def content_length
      puts "ENV #{@env.inspect}"
      @env[:response_headers][CONTENT_LENGTH]
      @env[:link]
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
