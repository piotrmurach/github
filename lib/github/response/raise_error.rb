# encoding: utf-8

require 'faraday'

module Github
  class Response::RaiseError < Faraday::Response::Middleware
    
    def on_complete(env)
      case env[:status].to_i
      when 400
        raise Github::BadRequest.new(response_message(env), env[:response_headers])
      when 401
        raise Github::Unauthorised.new(response_message(env), env[:response_headers])
      when 403
        raise Github::Forbidden.new(response_message(env), env[:response_headers])
      when 404
        raise Github::ResourceNotFound.new(response_message(env), env[:response_headers])
      when 500
        raise Github::InternalServerError.new(response_message(env), env[:response_headers])
      when 503
        raise Github::ServiceUnavailable.new(response_message(env), env[:response_headers])
      when 400...600
        raise Github::Error.new(response_message(env), env[:response_headers])
      end
    end

    def response_message(env)
      "#{env[:method].to_s.upcase} #{env[:url].to_s}: #{env[:status]}#{env[:body]}"
    end

  end # Response::RaiseError
end # Github
