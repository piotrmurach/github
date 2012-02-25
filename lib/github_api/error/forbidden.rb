# encoding: utf-8

module Github #:nodoc
  # Raised when Github returns the HTTP status code 403
  module Error
    class Forbidden < GithubError
      def initialize(env)
        super(env)
      end
    end
  end # Error
end # Github
