# encoding: utf-8

require 'delegate'
require 'base64'

module Github
  # Class responsible for holding request parameters
  class ParamsHash < DelegateClass(Hash)
    include Normalizer
    include MimeType

    REQUEST_PARAMS = [:accept, :media, :data, :raw, :content_type, :headers]

    def initialize(hash)
      super(normalize!(Hash[hash]))
    end

    # Create empty hash
    #
    # @api public
    def self.empty
      new({})
    end

    # Extract and parse media type param
    #
    #  [.version].param[+json]
    #
    # @api public
    def media
      parse(delete('media'))
    end

    # Get accept header
    #
    # @api public
    def accept
      if key?('accept') then self['accept']
      elsif key?('media') then media
      else nil
      end
    end

    # Extract request data from parameters
    #
    # @api public
    def data
      if key?('data') && !self['data'].nil?
        self['data']
      else
        request_params
      end
    end

    def encoder
      if key?('encoder') && self['encoder']
        self['encoder']
      else
        {}
      end
    end

    # Configuration options from request
    #
    # @return [Hash]
    #
    # @api public
    def options
      opts    = fetch('options', {})
      headers = fetch('headers', {})
      if value = accept
        headers[:accept] = value
      end
      if self['content_type']
        headers[:content_type] = self['content_type']
      end
      opts[:raw]     = key?('raw') ? self['raw'] : false
      opts[:headers] = headers unless headers.empty?
      opts
    end

    # Update hash with default parameters for non existing keys
    #
    def merge_default(defaults)
      if defaults && !defaults.empty?
        defaults.each do |key, value|
          self[key] = value unless self.key?(key)
        end
      end
      self
    end

    # Base64 encode string removing newline characters
    #
    # @api public
    def strict_encode64(key)
      value = self[key]
      encoded = if Base64.respond_to?(:strict_encode64)
                  Base64.strict_encode64(value)
                else
                  [value].pack('m0')
                end
      self[key] = encoded.delete("\n\r")
    end

    # Filter out request params
    #
    # @api public
    def request_params
      to_hash.select do |key, value|
        !REQUEST_PARAMS.include?(key.to_sym)
      end
    end
  end # ParamsHash
end # Github
