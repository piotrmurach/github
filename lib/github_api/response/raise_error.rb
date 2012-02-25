# encoding: utf-8

require 'faraday'
require 'github_api/error'

module Github
  class Response::RaiseError < Faraday::Response::Middleware

    def on_complete(env)
      case env[:status].to_i
      when 400
        raise Github::Error::BadRequest.new(env)
      when 401
        raise Github::Error::Unauthorized.new(env)
      when 403
        raise Github::Error::Forbidden.new(env)
      when 404
        raise Github::Error::NotFound.new(env)
      when 422
        raise Github::Error::UnprocessableEntity.new(env)
      when 500
        raise Github::Error::InternalServerError.new(env)
      when 503
        raise Github::Error::ServiceUnavailable.new(env)
      when 400...600
        raise Github::Error::ServiceError.new(env)
      end
    end

  end # Response::RaiseError
end # Github
