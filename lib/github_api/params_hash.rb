# encoding: utf-8

require 'delegate'

module Github

  # Class responsible for holding request parameters
  class ParamsHash < DelegateClass(Hash)
    include Normalizer
    include MimeType

    def initialize(hash)
      super(normalize!(Hash[hash]))
    end

    # Extract and parse media type param
    #
    #  [.version].param[+json]
    #
    def media
      parse(self.delete('media'))
    end

    # Return accept header if present
    #
    def accept
      if has_key?('accept')
        self.delete('accept')
      elsif has_key?('media')
        media
      else
        nil
      end
    end

    # Extract request data from paramters
    #
    def data
      if has_key?('data') && !self['data'].nil?
        return self.delete('data')
      else
        return self.to_hash
      end
    end

    # Any client configuration options
    #
    def options
      hash = has_key?('options') ? self.delete('options') : {}
      if value = accept
        hash[:headers] = {} unless hash.has_key?(:headers)
        hash[:headers]['Accept'] = value
      end
      hash[:raw] = has_key?('raw') ? self.delete('raw') : false
      hash
    end

    # Update hash with default parameters for non existing keys
    #
    def merge_default(defaults)
      if defaults && !defaults.empty?
        defaults.each do |key, value|
          self[key] = value unless self.has_key?(key)
        end
      end
      self
    end

  end # ParamsHash
end # Github
