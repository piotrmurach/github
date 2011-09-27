module Github
  module Configuration
      
    VALID_OPTIONS_KEYS = [
      :adapter,
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
      :endpoint
    ]

    # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
    #
    DEFAULT_ADAPTER = :net_http

    DEFAULT_ENDPOINT = 'https://api.github.com/'.freeze

    DEFAULT_USER_AGENT = "Github Ruby Gem #{Github::Version::STRING}".freeze

    attr_accessor *VALID_OPTIONS_KEYS
 
    def configure
      yield self
    end

  end
end
