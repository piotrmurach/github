module Github
  module Filter

    def process_params(*args)
      yield self if block_given?
    end

    def normalize(params)
      _normalize_params_keys params
    end

    def filter(keys, params)
      _filter_params_keys(keys, params)
    end

    # Turns any keys from nested hashes including nested arrays into strings
    def _normalize_params_keys(params)  #  :nodoc:
      case params
      when Hash
        params.keys.each do |k|
          params[k.to_s] = params.delete(k)
          _normalize_params_keys(params[k.to_s])
        end
      when Array
        params.map! do |el|
          _normalize_params_keys(el)
        end
      else
        params.to_s
      end
      return params
    end

    # Removes any keys from nested hashes that don't match predefiend keys
    def _filter_params_keys(keys, params, options={:recursive => true})  # :nodoc:
      case params
      when Hash
        params.keys.each do |k, v|
          unless (keys.include?(k) or Github::Validations::VALID_API_KEYS.include?(k))
            params.delete(k)
          else
            _filter_params_keys(keys, params[k]) if options[:recursive]
          end
        end
      when Array
        params.map! do |el|
          _filter_params_keys(keys, el) if options[:recursive]
        end
      else
        params
      end
      return params
    end

  end # Filter
end # Github
