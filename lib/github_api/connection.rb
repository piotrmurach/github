# encoding: utf-8

require 'faraday'
require 'github_api/response'
require 'github_api/response/mashify'
require 'github_api/response/jsonize'
require 'github_api/response/helpers'
require 'github_api/response/raise_error'
require 'github_api/request/oauth2'
require 'github_api/request/basic_auth'
require 'github_api/request/jsonize'

module Github
  module Connection
    include Github::Constants

    ALLOWED_OPTIONS = [
      :headers,
      :url,
      :params,
      :request,
      :ssl
    ].freeze

    def default_options(options={}) # :nodoc:
      {
        :headers => {
          "Accept"         => "application/vnd.github.v3.raw+json," \
                              "application/vnd.github.beta.raw+json;q=0.5," \
                              "application/json;q=0.1",
          "Accept-Charset" => "utf-8",
          "User-Agent"     => user_agent,
          CONTENT_TYPE     => 'application/x-www-form-urlencoded'
        },
        :ssl => { :verify => false },
        :url => endpoint
      }.merge(options)
    end

    def clear_cache # :nodoc:
      @connection = nil
    end

    def caching? # :nodoc:
      !@connection.nil?
    end

    def connection(options = {}) # :nodoc:

      conn_options = default_options(options)
      clear_cache unless options.empty?

      @connection ||= begin
        Faraday.new(conn_options) do |builder|
          puts conn_options.inspect if ENV['DEBUG']

          builder.use Github::Request::Jsonize
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Response::Logger if ENV['DEBUG']

          builder.use Github::Request::OAuth2, oauth_token if oauth_token?
          builder.use Github::Request::BasicAuth, authentication if basic_authed?

          builder.use Github::Response::Helpers
          unless options[:raw]
            builder.use Github::Response::Mashify
            builder.use Github::Response::Jsonize
          end

          builder.use Github::Response::RaiseError
          builder.adapter adapter
        end
      end
    end

  end # Connection
end # Github
