# encoding: utf-8

module Github
  # Deals with normalazing client supplied parameter keys.
  module Normalizer
    # Turns any keys from nested hashes including nested arrays into strings
    #
    def normalize!(params)
      case params
      when Hash
        params.keys.each do |k|
          params[k.to_s] = params.delete(k)
          normalize!(params[k.to_s])
        end
      when Array
        params.map! do |el|
          normalize!(el)
        end
      else
        params.to_s
      end
      return params
    end
  end # Normalizer
end # Github
