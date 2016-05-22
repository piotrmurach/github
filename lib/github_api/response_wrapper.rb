# encoding: utf-8

module Github
  # A class responsible for proxing to faraday response
  class ResponseWrapper
    extend Forwardable
    include Pagination
    include Enumerable

    attr_reader :response

    attr_reader :current_api

    attr_reader :env

    def_delegators :body, :empty?, :size, :include?, :length, :to_a, :first, :flatten, :include?, :keys, :[]

    def initialize(response, current_api)
      @response    = response
      @current_api = current_api
      @env         = response.env
    end

    # Overwrite methods to hash keys
    #
    ['id', 'type', 'fork'].each do |method_name|
      define_method(method_name) do
        self.body.fetch(method_name.to_s)
      end
    end

    # Request url
    #
    def url
      response.env[:url].to_s
    end

    def body=(value)
      @body = value
      @env[:body] = value
    end

    # Response raw body
    #
    def body
      @body ? @body : response.body
    end

    # Response status
    #
    def status
      response.status
    end

    def success?
      response.success?
    end

    def redirect?
      status.to_i >= 300 && status.to_i < 400
    end

    def client_error?
      status.to_i >= 400 && status.to_i < 500
    end

    def server_error?
      status.to_i >= 500 && status.to_i < 600
    end

    # Return response headers
    #
    def headers
      Github::Response::Header.new(env)
    end

    # Lookup an attribute from the body if hash, otherwise behave like array index.
    # Convert any key to string before calling.
    #
    def [](key)
      if self.body.is_a?(Array)
        self.body[key]
      else
        self.body.send(:"#{key}")
      end
    end

    # Return response body as string
    #
    def to_s
      body.to_s
    end

    # Convert the ResponseWrapper into a Hash
    #
    def to_hash
      body.to_hash
    end

    # Convert the ResponseWrapper into an Array
    #
    def to_ary
      body.to_ary
    end

    # Iterate over each resource inside the body
    #
    def each
      body_parts = self.body.respond_to?(:each) ? self.body : [self.body]
      return body_parts.to_enum unless block_given?
      body_parts.each { |part| yield(part) }
    end

    # Check if body has an attribute
    #
    def has_key?(key)
      self.body.is_a?(Hash) && self.body.has_key?(key)
    end

    # Coerce any method calls for body attributes
    #
    def method_missing(method_name, *args, &block)
      if self.has_key?(method_name.to_s)
        self.[](method_name, &block)
      else
        super
      end
    end

    # Check if method is defined on the body
    #
    def respond_to?(method_name, include_all = false)
      if self.has_key?(method_name.to_s)
        true
      else
        super
      end
    end

    # Print only response body
    #
    def inspect
      "#<#{self.class.name} @body=\"#{self.body}\">"
    end

    # Compare the wrapper with other wrapper for equality
    #
    def ==(other)
      return false unless other.is_a?(self.class)
      return false unless (other.respond_to?(:env) && other.respond_to?(:body))
      self.env == other.env && self.body == other.body
    end
    alias eql? ==

  end # ResponseWrapper
end # Github
