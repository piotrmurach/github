# encoding: utf-8

require 'faraday'
require 'github_api/response'
require 'github_api/response/mashify'
require 'github_api/response/jsonize'
require 'github_api/response/helpers'
require 'github_api/response/raise_error'
require 'github_api/request/oauth2'
require 'github_api/request/basic_auth'

module Github
  module Connection

  ALLOWED_OPTIONS = [
    :headers,
    :url,
    :params,
    :request,
    :ssl
  ].freeze

  private

    def default_options(options={}) # :nodoc:
      {
#         :headers => {
#           'Accept'       => '*/*', #accepts,
#           'User-Agent'   => user_agent,
#           'Content-Type' => 'application/x-www-form-urlencoded'
#         },
        :ssl => { :verify => false },
        :url => endpoint
      }
    end

    def clear_cache # :nodoc:
      @connection = nil
    end

    def caching? # :nodoc:
      !@connection.nil?
    end

    def connection(options = {}) # :nodoc:

      # merged_options = _filter_params_keys(ALLOWED_OPTIONS, header_options.merge(options))
      clear_cache unless options.empty?

      @connection ||= begin
        Faraday.new(default_options.merge(options)) do |builder|
          puts options.inspect

          builder.use Faraday::Request::JSON
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Response::Logger

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
