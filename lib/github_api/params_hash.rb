# encoding: utf-8

module Github

  # Class responsible for holding request parameters
  class ParamsHash < DelegateClass(Hash)
    include Normalizer

    def initialize(hash)
      super(normalize!(Hash[hash]))
    end

    def mime
      self['mime']
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
