module Github
  module Configuration
      
    VALID_OPTIONS_KEYS = [
      :adapter,
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
      :endpoint,
      :format,
      :user_agent,
      :faraday_options
    ].freeze

    # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
    DEFAULT_ADAPTER = :net_http

    # By default, don't set an application key
    DEFAULT_CONSUMER_KEY = nil

    # By default, don't set an application secret
    DEFAULT_CONSUMER_SECRET = nil

    DEFAULT_OAUTH_TOKEN = nil

    DEFAULT_OAUTH_TOKEN_SECRET = nil
    
    # The endpoint used to connect to GitHub if none is set
    DEFAULT_ENDPOINT = 'https://api.github.com/'.freeze

    DEFAULT_USER_AGENT = "Github Ruby Gem #{Github::Version::STRING}".freeze

    DEFAULT_FARADAY_OPTIONS = {}

    attr_accessor *VALID_OPTIONS_KEYS
    
    # Convenience method to allow for global setting of configuration options
    def configure
      yield self
    end

    def self.extended(base)
      base.set_defaults
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
    end

    def set_defaults
      self.adapter            = DEFAULT_ADAPTER
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self.faraday_options    = DEFAULT_FARADAY_OPTIONS
      self
    end

  end
end
