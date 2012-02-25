# encoding: utf-8

module Github #:nodoc
  # Raised when Github returns the HTTP status code 404
  module Error
    class ServiceError < GithubError
      attr_accessor :http_headers

      def initialize(env)
        super(generate_message(env))
        @http_headers = env[:response_headers]
      end

      def generate_message(env)
        "#{env[:method].to_s.upcase} #{env[:url].to_s}: #{env[:status]} #{env[:body]}"
      end
    end
  end # Error
end # Github
