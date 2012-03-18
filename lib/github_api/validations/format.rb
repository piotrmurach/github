# encoding: utf-8

module Github
  module Validations
    module Format

      # Ensures that value for a given key is of the correct form whether
      # matching regular expression or set of predefined values.
      #
      def _validate_params_values(permitted, params)
        params.each do |k, v|
          next unless permitted.keys.include?(k)
          if permitted[k].is_a?(Array) && !permitted[k].include?(params[k])
            raise ArgumentError, "Wrong value for #{k}, allowed: #{permitted[k].join(', ')}"
          elsif permitted[k].is_a?(Regexp) && !(permitted[k] =~ params[k])
            raise ArgumentError, "String does not match the parameter value."
          end
        end
      end

    end # Format
  end # Validations
end # Github
