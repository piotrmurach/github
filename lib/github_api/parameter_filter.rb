# -*- encoding: utf-8 -*-

module Github
  # Allows you to specify parameters keys which will be preserved
  # in parameters hash and its subhashes. Any keys from the nested
  # hash that do not match will be removed.
  module ParameterFilter

    # Removes any keys from nested hashes that don't match predefiend keys
    #
    def filter!(keys, params, options={:recursive => true})  # :nodoc:
      case params
      when Hash, ParamsHash
        params.keys.each do |k, v|
          unless (keys.include?(k) or Github::Validations::VALID_API_KEYS.include?(k))
            params.delete(k)
          else
            filter!(keys, params[k]) if options[:recursive]
          end
        end
      when Array
        params.map! do |el|
          filter!(keys, el) if options[:recursive]
        end
      else
        params
      end
      return params
    end

  end # Filter
end # Github
