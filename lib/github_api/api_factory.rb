# encoding: utf-8

require 'github_api/core_ext/hash'

module Github
  class ApiFactory

    # Instantiates a new github api object
    def self.new(klass, options={})
      return _create_instance(klass, options) if klass
      raise ArgumentError, 'must provied klass to be instantiated'
    end

  private

    # Passes configuration options to instantiated class
    def self._create_instance(klass, options)
      options.symbolize_keys!
      instance = Github.const_get(klass.to_sym).new options
      Github.api_client = instance
      instance
    end
  end
end # Github
