# encoding: utf-8

require 'github/configuration'
require 'github/connection'
require 'github/request'

module Github
  # @private
  class API
    include Connection
    include Request

    VALID_API_KEYS = [
      :per_page,
      :pagination
    ]

    attr_reader *Configuration::VALID_OPTIONS_KEYS
    attr_accessor *VALID_API_KEYS
    
    # Callback to update global configuration options
    class_eval do
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
          Github.send("#{key}=", arg)
        end
      end
    end
   
    # Creates new API 
    def initialize(options = {})
      options = Github.options.merge(options)   
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    private

    # Responds to attribute query
    def method_missing(method, *args, &block)
      if method.to_s =~ /^(.*)\?$/ 
        return !self.send($1.to_s).nil? 
      else
        super
      end
    end

    def _validate_inputs(required, provided)
      required.all? do |key|
        provided.has_key? key
      end
    end

    def _validate_user_repo_params(user_name, repo_name)
      raise ArgumentError, "[user] parameter cannot be nil" if user_name.nil?
      raise ArgumentError, "[repo] parameter cannot be nil" if repo_name.nil?
    end

    def _update_user_repo_params(user_name, repo_name)
      self.user = user_name || self.user
      self.repo = repo_name || self.repo
    end

    def _normalize_params_keys(params)
      case params
      when Hash
        params.keys.each do |k|
          params[k.to_s] = params[delete(k)]
          _normalize_params_keys(params[k.to_s])
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
    
    # Passes configuration options to instantiated class
    # TODO implement 
    # @private
    def _create_instance(klass)
      klass.new(options) 
    end
  
    def _token_required

    end


  end

end
