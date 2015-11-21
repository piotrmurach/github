# encoding: utf-8

module Github
  module Validations
    module Required
      # Validate all keys present in a provided hash against required set,
      # on mismatch raise Github::Error::RequiredParams
      # Note that keys need to be in the same format i.e. symbols or strings,
      # otherwise the comparison will fail.
      #
      # @api public
      def assert_required_keys(*required, provided)
        required.flatten.all? { |key|
          provided.deep_key?(key.to_s)
        } || (raise Github::Error::RequiredParams.new(provided, required))
      end
    end # Required
  end # Validations
end # Github
