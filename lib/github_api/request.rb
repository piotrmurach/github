# encoding: utf-8

require 'github_api/request/actions'
require 'github_api/request/connection'

module Github

  # Base class for HTTP requests
  class Request
    extend Request::Actions
    include Request::Connection

    METHODS = [:get, :post, :put, :delete, :patch].freeze

    METHODS_WITH_BODIES = [ :post, :put, :patch ].freeze

    attr_reader :method

    attr_reader :path

    attr_reader :params

    attr_reader :options

    def initialize(method, path, params={}, options={})
      if !METHODS.include?(method)
        raise ArgumentError, "unkown http method: #{method}"
      end
      @method  = method
      @path    = path
      @params  = params
      @options = options
    end

    # Run a request
    #
    def run
      puts "EXECUTED: #{method} - #{path} with #{params} and #{options}" if ENV['DEBUG']

      conn = connection(options)
      path = (conn.path_prefix + path).gsub(/\/\//,'/') if conn.path_prefix != '/'

      response = conn.send(method) do |request|
        case method.to_sym
        when *(METHODS - METHODS_WITH_BODIES)
          request.body = params.delete('data') if params.has_key?('data')
          request.url(path, params)
        when *METHODS_WITH_BODIES
          request.path = path
          request.body = extract_data_from_params(params) unless params.empty?
        end
      end
      response.body
    end

    def finish(response)
      
    end

    private

    def extract_data_from_params(params) # :nodoc:
      return params['data'] if params.has_key?('data') and !params['data'].nil?
      return params
    end

#     def _extract_mime_type(params, options) # :nodoc:
#       options['resource']  = params['resource'] ? params.delete('resource') : ''
#       options['mime_type'] = params['resource'] ? params.delete('mime_type') : ''
#     end

  end # Request
end # Github
