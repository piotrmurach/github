# encoding: utf-8

require_relative 'connection'
require_relative 'response_wrapper'
require_relative 'request/oauth2'
require_relative 'request/basic_auth'
require_relative 'request/jsonize'

module Github
  # A class responsible for dispatching http requests
  class Request
    include Connection

    HTTP_METHODS = [:get, :head, :post, :put, :delete, :patch]

    METHODS_WITH_BODIES = [:post, :put, :patch]

    # Return http verb
    #
    # @return [Symbol]
    attr_reader :action

    # Return url
    #
    # @return [String]
    attr_accessor :path

    # Return api this request is associated with
    #
    # @return [Github::API]
    attr_reader :api

    # Create a new Request
    #
    # @return [Github::Request]
    #
    # @api public
    def initialize(action, path, api)
      @action = action
      @path   = path
      @api    = api
    end

    # Performs a request
    #
    # @param current_options [Hash]
    # @param [ParamsHash] params - ParamsHash to configure the request API
    #
    # @return [Github::ResponseWrapper]
    #
    # @api private
    def call(current_options, params)
      unless HTTP_METHODS.include?(action)
        raise ArgumentError, "unknown http method: #{action}"
      end

      puts "EXECUTED: #{action} - #{path} with PARAMS: #{params.request_params}" if ENV['DEBUG']

      request_options    = params.options
      connection_options = current_options.merge(request_options)
      conn               = connection(api, connection_options)

      self.path = Utils::Url.normalize(self.path)
      if conn.path_prefix != '/' && self.path.index(conn.path_prefix) != 0
        self.path = (conn.path_prefix + self.path).gsub(/\/(\/)*/, '/')
      end

      response = conn.send(action) do |request|
        case action.to_sym
        when *(HTTP_METHODS - METHODS_WITH_BODIES)
          request.body = params.data if params.key?('data')
          if params.key?('encoder')
            request.params.params_encoder(params.encoder)
          end
          request.url(self.path, params.request_params)
        when *METHODS_WITH_BODIES
          request.url(self.path, connection_options[:query] || {})
          request.body = params.data unless params.empty?
        end
      end
      ResponseWrapper.new(response, api)
    end
  end # Request
end # Github
