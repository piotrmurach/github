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

    # Request url
    #
    def url
      response.env[:url].to_s
    end

    # Response raw body
    #
    def body
      response.body
    end

    # Response status
    #
    def status
      response.status
    end

    def success?
      response.success?
    end

    # Return response headers
    #
    def headers
      Github::Response::Header.new(env)
    end

    # Lookup an attribute from the body.
    # Convert any key to string before calling.
    #
    def [](key)
      self.body.send(:"#{key}")
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
      !self.body.is_a?(Array) && self.body.has_key?(key)
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
    def respond_to?(method_name)
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
      self.env == other.env &&
      self.body == other.body
    end

  end # ResponseWrapper
end # Github
