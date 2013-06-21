# encoding: utf-8

require 'faraday'
require 'github_api/error'

module Github
  class Response::RaiseError < Faraday::Response::Middleware

    def on_complete(env)
      status_code   = env[:status].to_i
      service_error = Github::Error::ServiceError
      error_class = service_error.errors[status_code]
      error_class = service_error if !error_class and (400...600) === status_code
      raise error_class.new(env) if error_class
    end

  end # Response::RaiseError
end # Github
