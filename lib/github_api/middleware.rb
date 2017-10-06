# encoding: utf-8

require_relative 'response'
require_relative 'response/mashify'
require_relative 'response/jsonize'
require_relative 'response/atom_parser'
require_relative 'response/raise_error'
require_relative 'response/header'
require_relative 'response/follow_redirects'

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

        builder.use Github::Response::FollowRedirects if api.follow_redirects
        builder.use Faraday::Response::Logger if ENV['DEBUG']
        unless options[:raw]
          builder.use Github::Response::Mashify
          builder.use Github::Response::Jsonize
          builder.use Github::Response::AtomParser
        end
        if api.stack
          api.stack.call(builder)
        end
        builder.use Github::Response::RaiseError
        builder.adapter options[:adapter]
      end
    end
  end # Middleware
end # Github
