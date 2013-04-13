# encoding: utf-8

module Github

  # Class responsible for holding request parameters
  class ParamsHash < DelegateClass(Hash)
    include Normalizer

    def initialize(hash)
      super(normalize!(hash))
    end

    def mime
      hash['mime']
    end

    def data
      if has_key?('data') && !self['data'].nil?
        return self['data']
      else
        return self
      end
    end

  end # ParamsHash
end # Github
