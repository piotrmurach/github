# encoding: utf-8

require 'github_api/descendants'

module Github
  module Error
    class GithubError < StandardError
      extend Descendants

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
  bad_request
  unauthorized
  forbidden
  not_found
  not_acceptable
  unprocessable_entity
  internal_server_error
  service_unavailable
  client_error
  invalid_options
  required_params
  unknown_value
  validations
].each do |error|
  require "github_api/error/#{error}"
end
