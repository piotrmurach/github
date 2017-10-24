# encoding: utf-8

require 'faraday'

module Github

  # Skip encoding of the key nested parameters
  module NullParamsEncoder
    if defined?(Faraday::NestedParamsEncoder)
      class << self
        Faraday::NestedParamsEncoder.singleton_methods do |m|
          define_method m, ::Faraday::NestedParamsEncoder.method(m).to_proc
        end
      end
    end

    def self.escape(s)
      s.to_s
    end

    def self.unescape(s)
      s.to_s
    end
  end # NullEncoder
end # Github
