module Github
  module Validation

    VALID_API_KEYS = [
      'page',
      'per_page',
      'jsonp_callback'
    ]

    # Ensures that esential input parameters are present before request is made
    #
    def _validate_inputs(required, provided)
      required.all? do |key|
        provided.has_deep_key? key
      end
    end

    # Ensures that esential arguments are present before request is made
    #
    def _validate_presence_of(*params)
      params.each do |param|
        raise ArgumentError, "parameter cannot be nil" if param.nil?
      end
    end

    # Check if user or repository parameters are passed
    #
    def _validate_user_repo_params(user_name, repo_name)
      raise ArgumentError, "[user] parameter cannot be nil" if user_name.nil?
      raise ArgumentError, "[repo] parameter cannot be nil" if repo_name.nil?
    end

    # Ensures that hash values contain predefined values
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

  end # Validation
end # Github
