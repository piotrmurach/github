# encoding: utf-8

require 'github_api/version'
require 'github_api/configuration'
require 'github_api/constants'
require 'github_api/utils/url'
require 'github_api/connection'
require 'github_api/deprecation'
require 'github_api/core_ext/ordered_hash'
require 'github_api/core_ext/deep_merge'

module Github
  extend Configuration

  class << self

    # Alias for Github::Client.new
    #
    # @return [Github::Client]
    def new(options = {}, &block)
      Github::Client.new(options, &block)
    end

    # Delegate to Github::Client
    #
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end

  end

  module AutoloadHelper

    def autoload_all(prefix, options)
      options.each do |const_name, path|
        autoload const_name, File.join(prefix, path)
      end
    end

    def register_constant(options)
      options.each do |const_name, value|
        const_set const_name.upcase.to_s, value
      end
    end

    def lookup_constant(const_name)
      const_get const_name.upcase.to_s
    end

  end

  extend AutoloadHelper

  autoload_all 'github_api',
    :API             => 'api',
    :Arguments       => 'arguments',
    :Activity        => 'activity',
    :ApiFactory      => 'api_factory',
    :Client          => 'client',
    :Repos           => 'repos',
    :Request         => 'request',
    :Response        => 'response',
    :ResponseWrapper => 'response_wrapper',
    :Result          => 'result',
    :Error           => 'error',
    :Issues          => 'issues',
    :Gists           => 'gists',
    :GitData         => 'git_data',
    :Gitignore       => 'gitignore',
    :Orgs            => 'orgs',
    :PullRequests    => 'pull_requests',
    :Users           => 'users',
    :Emojis          => 'emojis',
    :Search          => 'search',
    :Say             => 'say',
    :Scopes          => 'scopes',
    :Markdown        => 'markdown',
    :Meta            => 'meta',
    :CoreExt         => 'core_ext',
    :MimeType        => 'mime_type',
    :Authorization   => 'authorization',
    :Authorizations  => 'authorizations',
    :Pagination      => 'pagination',
    :PageLinks       => 'page_links',
    :PageIterator    => 'page_iterator',
    :PagedRequest    => 'paged_request',
    :Validations     => 'validations',
    :ParameterFilter => 'parameter_filter',
    :ParamsHash      => 'params_hash',
    :Normalizer      => 'normalizer'

end # Github
