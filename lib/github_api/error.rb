# encoding: utf-8

module Github
  module Error
    class GithubError < StandardError
      attr_reader :response_message, :response_headers

      # Initialize a new Github error object.
      #
      def initialize(message=$!)
        if message.respond_to?(:backtrace)
          super(message.message)
          @response_message = message
        else
          super(message.to_s)
        end
      end

      def backtrace
        @response_message ? @response_message.backtrace : super
      end

    end # GithubError
  end # Error
end # Github

%w[
  service_error
  not_found
  forbidden
  bad_request
  unauthorized
  service_unavailable
  internal_server_error
  unprocessable_entity
  client_error
  invalid_options
  required_params
  unknown_value
].each do |error|
  require "github_api/error/#{error}"
end
