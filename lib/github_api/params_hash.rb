# encoding: utf-8

require 'delegate'
require 'base64'

module Github

  # Class responsible for holding request parameters
  class ParamsHash < DelegateClass(Hash)
    include Normalizer
    include MimeType

    def initialize(hash)
      super(normalize!(Hash[hash]))
    end

    # Create empty hash
    #
    def self.empty
      new({})
    end

    # Extract and parse media type param
    #
    #  [.version].param[+json]
    #
    def media
      parse(delete('media'))
    end

    # Return accept header if present
    #
    def accept
      if has_key?('accept')
        delete('accept')
      elsif has_key?('media')
        media
      else
        nil
      end
    end

    # Extract request data from parameters
    #
    def data
      if has_key?('data') && !self['data'].nil?
        return delete('data')
      else
        return to_hash
      end
    end

    def encoder
      if has_key?('encoder') && self['encoder']
        return delete('encoder')
      else
        return {}
      end
    end

    # Any client configuration options
    #
    def options
      opts = has_key?('options') ? delete('options') : {}
      headers = opts.fetch(:headers) { {} }
      if value = accept
        headers[:accept] = value
      end
      if value = delete('content_type')
        headers[:content_type] = value
      end
      opts[:raw] = has_key?('raw') ? delete('raw') : false
      opts[:headers] = headers unless headers.empty?
      opts
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

    # Base64 encode string removing newline characters
    #
    def strict_encode64(key)
      value = self[key]
      encoded = if Base64.respond_to?(:strict_encode64)
        Base64.strict_encode64(value)
      else
        [value].pack("m0")
      end
      self[key] = encoded.delete("\n\r")
    end

  end # ParamsHash
end # Github
