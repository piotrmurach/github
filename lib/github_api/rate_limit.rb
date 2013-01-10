# encoding: utf-8

module Github
  module RateLimit

    def ratelimit
      get_request("/rate_limit").rate.limit
    end

    def ratelimit_remaining
      get_request("/rate_limit").rate.remaining
    end

  end # RateLimit
end # Github
