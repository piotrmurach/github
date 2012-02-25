# encoding: utf-8

module Github #:nodoc
  # Raised when Github returns the HTTP status code 401
  module Error
    class Unauthorized < GithubError
      def initialize(env)
        super(env)
      end
    end
  end # Error
end # Github
