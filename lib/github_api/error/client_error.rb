# encoding: utf-8

module Github #:nodoc
  # Raised when Github returns the HTTP status code 404
  module Error
    class ClientError < GithubError
      attr_reader :problem, :summary, :resolution

      def initialize(message)
        super(message)
      end

      def generate_message(attributes)
        @problem = attributes[:problem]
        @summary = attributes[:summary]
        @resolution = attributes[:resolution]
        "\nProblem:\n #{@problem}"+
        "\nSummary:\n #{@summary}"+
        "\nResolution:\n #{@resolution}"
      end
    end
  end # Error
end # Github
