# encoding: utf-8

module Github
  module Validations
    module Required

      # Ensures that esential input parameters are present before request is made.
      #
      def _validate_inputs(required, provided)
        result = required.all? do |key|
          provided.has_deep_key? key
        end
        if !result
          raise Github::Error::RequiredParams.new(provided, required)
        end
        result
      end

    end # Required
  end # Validations
end # Github
