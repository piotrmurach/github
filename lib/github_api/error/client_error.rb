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
        "\nProblem:\n #{attributes[:problem]}"+
        "\nSummary:\n #{attributes[:summary]}"+
        "\nResolution:\n #{attributes[:resolution]}"
      end
    end
  end # Error
end # Github
