# encoding: utf-8

module Github #:nodoc
  # Raised when GitHub returns the HTTP status code 406
  module Error
    class NotAcceptable < ServiceError
      http_status_code 406

      def initialize(response)
        super(response)
      end

    end # NotAcceptable
  end # Error
end # Github
