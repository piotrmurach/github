# encoding: utf-8

module Github
  module Error
    # Raised when Github returns the HTTP status code 400
    class BadRequest < ServiceError
      def initialize(env)
        super(env)
      end
    end
  end
end # Github
