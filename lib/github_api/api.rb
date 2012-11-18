# -*- encoding: utf-8 -*-

require 'github_api/configuration'
require 'github_api/connection'
require 'github_api/validations'
require 'github_api/request'
require 'github_api/mime_type'
require 'github_api/rate_limit'
require 'github_api/core_ext/hash'
require 'github_api/core_ext/array'
require 'github_api/compatibility'
require 'github_api/api/actions'
require 'github_api/api_factory'

module Github
  # Core class for api interface operations
  class API
    include Constants
    include Authorization
    include MimeType
    include Connection
    include Request
    include RateLimit

    # TODO consider these optional in a stack
    include Validations
    include ParameterFilter
    include Normalizer

    attr_reader *Configuration::VALID_OPTIONS_KEYS

    attr_accessor *VALID_API_KEYS

    # Callback to update global configuration options
    class_eval do
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
          Github.send("#{key}=", arg)
        end
      end
    end

    # Creates new API
    def initialize(options={}, &block)
      super()
      setup options
      set_api_client
      client if client_id? && client_secret?

      self.instance_eval(&block) if block_given?
    end

    def setup(options={})
      options = Github.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
      process_basic_auth(options[:basic_auth])
    end

    # Extract login and password from basic_auth parameter
    def process_basic_auth(auth)
      case auth
      when String
        self.login, self.password = auth.split(':', 2)
      when Hash
        self.login    = auth[:login]
        self.password = auth[:password]
      end
    end

    # Assigns current api class
    def set_api_client
      Github.api_client = self
    end

    # Responds to attribute query or attribute clear.
    def method_missing(method, *args, &block) # :nodoc:
      case method.to_s
      when /^(.*)\?$/
        return !self.send($1.to_s).nil?
      when /^clear_(.*)$/
        self.send("#{$1.to_s}=", nil)
      else
        super
      end
    end

    # Acts as setter and getter for api requests arguments parsing.
    #
    def arguments(api=(not_set = true), options={})
      if not_set
        @arguments
      else
        @arguments = Arguments.new(api, options)
      end
    end

    # Scope for passing request required arguments.
    #
    def with(args)
      case args
      when Hash
        set args
      when /.*\/.*/i
        user, repo = args.split('/')
        set :user => user, :repo => repo
      else
        ::Kernel.raise ArgumentError, 'This api does not support passed in arguments'
      end
    end

    # Set an option to a given value
    def set(option, value=(not_set = true), &block)
      raise ArgumentError, 'value not set' if block and !not_set
      return self if !not_set and value.nil?

      if not_set
        set_options option
        return self
      end

      if respond_to?("#{option}=")
        return __send__("#{option}=", value)
      end

      define_accessors option, value
      self
    end

    private

    # Set multiple options
    #
    def set_options(options)
      unless options.respond_to?(:each)
        raise ArgumentError, 'cannot iterate over value'
      end
      options.each { |key, value| set(key, value) }
    end

    def define_accessors(option, value)
      setter = proc { |val| set option, value }
      getter = proc { value }

      define_singleton_method("#{option}=", setter) if setter
      define_singleton_method(option, getter) if getter
    end

    # Dynamically define a method for setting request option
    #
    def define_singleton_method(name, content=Proc.new)
      (class << self; self; end).class_eval do
        undef_method(name) if method_defined? name
        if String === content
          class_eval("def #{name}() #{content}; end")
        else
          define_method(name, &content)
        end
      end
    end

    def _merge_mime_type(resource, params) # :nodoc:
#       params['resource'] = resource
#       params['mime_type'] = params['mime_type'] || :raw
    end

  end # API
end # Github
