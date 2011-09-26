module Github
  class API
    
    include Connection 
    include Request

    include Repos
  
    def initialize

    end

    protected
    
    def _validate_inputs(required, provided)
      required.all? do |key|
        provided.has_key? key
      end
    end

    def _validate_user_repo_params

    end

    def _normalize_params_keys(params)
      case params
      when Hash
        params.keys.each do |k|
          params[k.to_s] = params[delete(k)]
        end
      when Array
        params.map! { |el| el.to_s }
      else
        params    
      end
      return params
    end

    def _filter_params_keys(keys, params)
      params.reject! { |k,v| !keys.include? k }
    end

  end

end
