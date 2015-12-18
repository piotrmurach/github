# encoding: utf-8

require 'github_api/api/config'

module Github
  # Stores the configuration
  class Configuration < API::Config

    # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
    property :adapter, default: :net_http

    # By default, don't traverse the page links
    property :auto_pagination, default: false

    # Basic authentication
    property :basic_auth

    # By default, don't set an application key
    property :client_id

    # By default, don't set an application secret
    property :client_secret

    # By default, don't set a user oauth access token
    property  :oauth_token

    # The api endpoint used to connect to GitHub if none is set
    property  :endpoint, default: 'https://api.github.com'.freeze

    # The web endpoint used to connect to GitHub if none is set
    property  :site, default: 'https://github.com'.freeze

    # The web endpoint used to upload release assets to GitHub if none is set
    property  :upload_endpoint, default: 'https://uploads.github.com'.freeze

    # The default SSL configuration
    property  :ssl, default: {
      :ca_file => File.expand_path('../ssl_certs/cacerts.pem', __FILE__)
    }

    # By default the Accept header will make a request for JSON
    property  :mime_type

    # The value sent in the http header for 'User-Agent' if none is set
    property  :user_agent, default: "Github API Ruby Gem #{Github::VERSION}".freeze

    # By default uses the Faraday connection options if none is set
    property  :connection_options, default: {}

    # Global repository name
    property :repo

    property :user

    property :org

    property :login

    property :password

    # By default display 30 resources
    property :per_page, default: 30

    # Add Faraday::RackBuilder to overwrite middleware
    property :stack
  end # Configuration
end # Github
