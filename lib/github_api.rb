# encoding: utf-8

require 'github_api/version'
require 'github_api/configuration'
require 'github_api/constants'
require 'github_api/utils/url'
require 'github_api/connection'
require 'github_api/deprecation'
require 'github_api/core_ext/ordered_hash'
require 'github_api/ext/faraday'

module Github
  LIBNAME = 'github_api'

  LIBDIR = File.expand_path("../#{LIBNAME}", __FILE__)

  class << self
    def included(base)
      base.extend ClassMethods
    end

    # Alias for Github::Client.new
    #
    # @param [Hash] options
    #   the configuration options
    #
    # @return [Github::Client]
    #
    # @api public
    def new(options = {}, &block)
      Github::Client.new(options, &block)
    end

    # Delegate to Github::Client
    #
    # @api private
    def method_missing(method_name, *args, &block)
      if new.respond_to?(method_name)
        new.send(method_name, *args, &block)
      elsif configuration.respond_to?(method_name)
        Github.configuration.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      new.respond_to?(method_name, include_private) ||
      configuration.respond_to?(method_name) ||
      super(method_name, include_private)
    end
  end

  module ClassMethods
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

    # Main client global configuration
    def configuration
      @configuration ||= Github::Configuration.new
    end
  end

  extend ClassMethods

  require_all LIBDIR,
    'authorization',
    'validations',
    'normalizer',
    'parameter_filter',
    'api',
    'arguments',
    'client',
    'repos',
    'pagination',
    'request',
    'response',
    'response_wrapper',
    'error',
    'mime_type',
    'page_links',
    'paged_request',
    'page_iterator',
    'params_hash'

end # Github
