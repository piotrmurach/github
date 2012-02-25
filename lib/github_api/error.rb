# encoding: utf-8

module Github
  module Error
    class GithubError < StandardError
      attr_reader :response_message, :response_headers

      def initialize(message)
        super message
        @response_message = message
      end

#       def inspect
#         %(#<#{self.class}>)
#       end
    end
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
].each do |error|
  require "github_api/error/#{error}"
end
