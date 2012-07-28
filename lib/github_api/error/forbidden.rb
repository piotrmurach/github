# encoding: utf-8

module Github #:nodoc
  # Raised when Github returns the HTTP status code 403
  module Error
    class Forbidden < ServiceError
      http_status_code 403

      def initialize(response)
        super(response)
      end
    end
  end # Error
end # Github
