# encoding: utf-8

module Github
  module Configuration

    VALID_OPTIONS_KEYS = [
      :adapter,
      :client_id,
      :client_secret,
      :oauth_token,
      :endpoint,
      :format,
      :resource,
      :user_agent,
      :faraday_options,
      :repo,
      :user
    ].freeze

    # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
    DEFAULT_ADAPTER = :net_http

    # By default, don't set an application key
    DEFAULT_CLIENT_ID = nil

    # By default, don't set an application secret
    DEFAULT_CLIENT_SECRET = nil

    # By default, don't set a user oauth access token
    DEFAULT_OAUTH_TOKEN = nil

    # The endpoint used to connect to GitHub if none is set
    DEFAULT_ENDPOINT = 'https://api.github.com/'.freeze

    # The value sent in the http header for 'User-Agent' if none is set
    DEFAULT_USER_AGENT = "Github Ruby Gem #{Github::Version::STRING}".freeze

    DEFAULT_FORMAT = :json

    # By default,  
    DEFAULT_RESOURCE = nil

    DEFAULT_FARADAY_OPTIONS = {}

    # By default, don't set user name
    DEFAULT_USER = nil

    # By default, don't set repository name
    DEFAULT_REPO = nil

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
      self.client_id          = DEFAULT_CLIENT_ID
      self.client_secret      = DEFAULT_CLIENT_SECRET
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self.faraday_options    = DEFAULT_FARADAY_OPTIONS
      self.format             = DEFAULT_FORMAT
      self.resource           = DEFAULT_RESOURCE
      self.user               = DEFAULT_USER
      self.repo               = DEFAULT_REPO
      self
    end

  end # Configuration
end # Github
