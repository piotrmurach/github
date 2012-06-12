# encoding: utf-8

module Github #:nodoc
  # Raised when invalid options are passed to a request body
  module Error
    class UnknownValue < ClientError
      def initialize(key, value, permitted)
        super(
          generate_message(
            :problem => "Wrong value of '#{value}' for the parameter: #{key} provided for this request.",
            :summary => "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and fails fast.",
            :resolution => "Permitted values are: #{permitted}, make sure these are the ones you are using"
          )
        )
      end
    end
  end # Error
end # Github
