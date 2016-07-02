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

    # Raised when invalid options are passed to a request body
    class InvalidOptions < ClientError
      def initialize(invalid, valid)
        super(
          generate_message(
            problem: "Invalid option #{invalid.keys.join(', ')} provided for this request.",
            summary: "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and to fail fast.",
            resolution: "Valid options are: #{valid.join(', ')}, make sure these are the ones you are using"
          )
        )
      end
    end

    # Raised when invalid options are passed to a request body
    class RequiredParams < ClientError
      def initialize(provided, required)
        super(
          generate_message(
            problem: "Missing required parameters: #{provided.keys.join(', ')} provided for this request.",
            summary: "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and to fail fast.",
            resolution: "Required parameters are: #{required.join(', ')}, make sure these are the ones you are using"
          )
        )
      end
    end

    # Raised when invalid options are passed to a request body
    class UnknownMedia < ClientError
      def initialize(file)
        super(
          generate_message(
            problem: "Unknown content type for: '#{file}' provided for this request.",
            summary: "Github gem infers the content type of the resource by calling the mime-types gem type inference.",
            resolution: "Please install mime-types gem to infer the resource content type."
          )
        )
      end
    end

    # Raised when invalid options are passed to a request body
    class UnknownValue < ClientError
      def initialize(key, value, permitted)
        super(
          generate_message(
            problem: "Wrong value of '#{value}' for the parameter: #{key} provided for this request.",
            summary: "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and fails fast.",
            resolution: "Permitted values are: #{permitted}, make sure these are the ones you are using"
          )
        )
      end
    end

    class Validations < ClientError
      def initialize(errors)
        super(
          generate_message(
            problem: "Attempted to send request with nil arguments for #{errors.keys.join(', ')}.",
            summary: 'Each request expects certain number of required arguments.',
            resolution: 'Double check that the provided arguments are set to some value that is neither nil nor empty string.'
          )
        )
      end
    end
  end # Error
end # Github
