# encoding: utf-8

require 'github_api/response'
require 'github_api/response/mashify'
require 'github_api/response/jsonize'
require 'github_api/response/atom_parser'
require 'github_api/response/raise_error'
require 'github_api/response/header'

module Github
  class Middleware
    def self.default(options = {})
      api = options[:api]
      proc do |builder|
        builder.use Github::Request::Jsonize
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Github::Request::OAuth2, api.oauth_token if api.oauth_token?
        builder.use Github::Request::BasicAuth, api.authentication if api.basic_authed?

        builder.use Faraday::Response::Logger if ENV['DEBUG']
        unless options[:raw]
          builder.use Github::Response::Mashify
          builder.use Github::Response::Jsonize
          builder.use Github::Response::AtomParser
        end
        builder.use Github::Response::RaiseError
        builder.adapter options[:adapter]
      end
    end
  end # Middleware
end # Github
