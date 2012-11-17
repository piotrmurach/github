# encoding: utf-8

module Github #:nodoc
  # Raised when passed parameters are missing or contain wrong values.
  module Error
    class Validations < ClientError
      def initialize(errors)
        super(
          generate_message(
            :problem => "Attempted to send request with nil arguments for #{errors.keys.join(', ')}.",
            :summary => 'Each request expects certain number of required arguments.',
            :resolution => 'Double check that the provided arguments are set to some value that is neither nil nor empty string.'
          )
        )
      end
    end
  end # Error
end # Github
