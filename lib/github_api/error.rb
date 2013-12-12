# encoding: utf-8

require 'descendants_tracker'

module Github
  module Error
    class GithubError < StandardError
      extend DescendantsTracker

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

require 'github_api/error/service_error'
require 'github_api/error/client_error'
Dir[File.dirname(__FILE__) + '/error/*.rb'].sort.each do |path|
  filename = File.basename(path)
  next if ['service_error.rb', 'client_error.rb'].include?(filename)
  require "github_api/error/#{filename}"
end
