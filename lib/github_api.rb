# encoding: utf-8

require 'github_api/version'
require 'github_api/configuration'
require 'github_api/constants'
require 'github_api/utils/url'
require 'github_api/connection'
require 'github_api/deprecation'
require 'github_api/core_ext/ordered_hash'
require 'github_api/core_ext/deep_merge'
require 'github_api/ext/faraday'

module Github
  extend Configuration

  LIBNAME = 'github_api'

  LIBDIR = File.expand_path("../#{LIBNAME}", __FILE__)

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

    # Requires internal github_api libraries
    #
    # @param [String] prefix
    #   the relative path prefix
    # @param [Array[String]] libs
    #   the array of libraries to require
    #
    # @return [self]
    def require_all(prefix, *libs)
      libs.each do |lib|
        require "#{File.join(prefix, lib)}"
      end
    end
  end

  require_all LIBDIR,
    'authorization',
    'validations',
    'normalizer',
    'parameter_filter',
    'api',
    'arguments',
    'activity',
    'api_factory',
    'client',
    'repos',
    'pagination',
    'request',
    'response',
    'response_wrapper',
    'error',
    'issues',
    'gists',
    'git_data',
    'gitignore',
    'orgs',
    'pull_requests',
    'users',
    'emojis',
    'search',
    'say',
    'scopes',
    'markdown',
    'meta',
    'mime_type',
    'authorizations',
    'page_links',
    'paged_request',
    'page_iterator',
    'params_hash'

end # Github
