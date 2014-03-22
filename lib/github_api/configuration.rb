# encoding: utf-8

require 'github_api/api/config'

module Github
  class Configuration < API::Config

    # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
    property :adapter, default: :net_http

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

    # The default SSL configuration
    property  :ssl, default: {
      :ca_file => File.expand_path('../ssl_certs/cacerts.pem', __FILE__)
    }

    # By default the <tt>Accept</tt> header will make a request for <tt>JSON</tt>
    property  :mime_type

    # The value sent in the http header for 'User-Agent' if none is set
    property  :user_agent, default: "Github Ruby Gem #{Github::VERSION::STRING}".freeze

    # By default uses the Faraday connection options if none is set
    property  :connection_options, default: {}

    property :repo

    property :user

    property :org

    property :login

    property :password

    property :basic_auth

    # By default, don't traverse the page links
    property :auto_pagination, default: false

  end # Configuration
end # Github
