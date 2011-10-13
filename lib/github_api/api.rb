# encoding: utf-8

require 'github_api/configuration'
require 'github_api/connection'
require 'github_api/request'

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
      @cached = Hash.new
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

    def _validate_presence_of(*params)
      params.each do |param|
        raise ArgumentError, "parameter cannot be nil" if param.nil?
      end
    end

    def _validate_user_repo_params(user_name, repo_name)
      raise ArgumentError, "[user] parameter cannot be nil" if user_name.nil?
      raise ArgumentError, "[repo] parameter cannot be nil" if repo_name.nil?
    end

    def _update_user_repo_params(user_name, repo_name=nil)
      self.user = user_name || self.user
      self.repo = repo_name || self.repo
    end

    def _merge_user_into_params!(params)
      params.merge!({ 'user' => self.user }) if user?
    end

    def _merge_user_repo_into_params!(params)
      { 'user' => self.user, 'repo' => self.repo }.merge!(params)
    end

    # Turns any keys from nested hashes including nested arrays into strings
    def _normalize_params_keys(params)
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

    def _filter_params_keys(keys, params)
      params.reject! { |k,v| !keys.include? k }
    end

    def _hash_traverse(hash, &block)
      hash.each do |key, val|
        block.call(key)
        case val
        when Hash
          val.keys.each do |k|
            _hash_traverse(val, &block)
          end
        when Array
          val.each do |item|
            _hash_traverse(item, &block)
          end
        end
      end
      return hash
    end

    def _validate_params_values(options, params)
      params.each do |k, v|
        next unless options.keys.include?(k)
        if options[k].is_a?(Array) && !options[k].include?(params[k])
          raise ArgumentError, "Wrong value for #{k}, allowed: #{options[k].join(', ')}"
        elsif options[k].is_a?(Regexp) && !(options[k] =~ params[k])
          raise ArgumentError, "String does not match the parameter value."
        end
      end
    end

    def _merge_parameters(params)
    end

    def _extract_parameters(array)
      if array.last.is_a?(Hash) && array.last.instance_of?(Hash)
        pop
      else
        {}
      end
    end

    # Passes configuration options to instantiated class
    # TODO implement 
    # @private
    def _create_instance(klass)
      klass.new(options)
    end

    def _token_required
    end

  end # API
end # Github
