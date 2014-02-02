# encoding: utf-8

module Faraday
  module Utils

    class ParamsHash
      def params_encoder(encoder = nil)
        if encoder
          @encoder = encoder
        else
          @encoder
        end
      end

      def to_query(encoder = nil)
        Utils.build_nested_query(self, nil, params_encoder)
      end
    end

    def build_nested_query(value, prefix = nil, encoder = nil)
      case value
      when Array
        value.map { |v| build_nested_query(v, "#{prefix}%5B%5D", encoder) }.join("&")
      when Hash
        value.map { |k, v|
          processed_value = encoder ? encoder.escape(k) : escape(k)
          build_nested_query(v, prefix ? "#{prefix}%5B#{processed_value}%5D" : processed_value, encoder)
        }.join("&")
      when NilClass
        prefix
      else
        raise ArgumentError, "value must be a Hash" if prefix.nil?
        processed_value = encoder ? encoder.escape(value) : escape(value)
        "#{prefix}=#{processed_value}"
      end
    end
  end
end
