# encoding: utf-8

require 'faraday'
require 'github_api/error'

module Github
  class Response::RaiseError < Faraday::Response::Middleware
    # Check if status code requires raising a ServiceError
    #
    # @api private
    def on_complete(env)
      status_code   = env[:status].to_i
      service_error = Github::Error::ServiceError
      error_class = service_error.error_mapping[status_code]
      if !error_class and (400...600) === status_code
        error_class = service_error
      end
      raise error_class.new(env) if error_class
    end
  end # Response::RaiseError
end # Github
