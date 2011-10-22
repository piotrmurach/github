# encoding: utf-8

require 'faraday'
require 'github_api/response'
require 'github_api/response/mashify'
require 'github_api/response/jsonize'
require 'github_api/response/raise_error'
require 'github_api/request/oauth2'
require 'github_api/request/basic_auth'

module Github
  module Connection

    # Available resources 
    RESOURCES = {
      :issue         => 'vnd.github-issue.',
      :issuecomment  => 'vnd.github-issuecomment.',
      :commitcomment => 'vnd.github-commitcomment',
      :pull          => 'vnd.github-pull.',
      :pullcomment   => 'vnd.github-pullcomment.',
      :gistcomment   => 'vnd.github-gistcomment.'
    }

    # Mime types used by resources
    RESOURCE_MIME_TYPES = {
      :raw  => 'raw+json',
      :text => 'text+json',
      :html => 'html+json',
      :full => 'html+full'
    }

    BLOB_MIME_TYPES = {
      :raw => 'vnd.github-blob.raw',
      :json => 'json'
    }

    def default_faraday_options()
      {
        :headers => {
          'Accept' => "application/#{resource}#{format}",
          'User-Agent' => user_agent
        },
        :ssl => { :verify => false },
        :url => endpoint
      }
    end

    # TODO Write mime format conversion

    # Create cache hash and store connection there and then pass it to @connection
    # add method to invalidate it if previous options are different from current

    def clear_cache
      @connection = nil
    end

    def caching?
      !@connection.nil?
    end

    def connection(options = {})
      merged_options = faraday_options.merge(default_faraday_options)

      clear_cache unless options.empty?

      @connection ||= begin
        Faraday.new(merged_options) do |builder|

          puts options.inspect

          builder.use Faraday::Request::JSON
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Response::Logger

          builder.use Github::Request::OAuth2, oauth_token if oauth_token?
          builder.use Github::Request::BasicAuth, login, password if login? && password?

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

