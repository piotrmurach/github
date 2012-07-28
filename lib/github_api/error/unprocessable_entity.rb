# encoding: utf-8

module Github #:nodoc
  # Raised when Github returns the HTTP status code 422
  module Error
    class UnprocessableEntity < ServiceError
      http_status_code 422

      def initialize(response)
        super(response)
      end
    end
  end # Error
end # Github
