require 'cgi'
require 'addressable/uri'

module Github
  module Utils
    module Url
      extend self

      DEFAULT_QUERY_SEP = /[&;] */n

      KEY_VALUE_SEP = '='.freeze

      def escape_uri(s) Addressable::URI.escape(s.to_s) end

      def escape(s) CGI.escape(s.to_s) end

      def unescape(s) CGI.unescape(s.to_s) end

      def normalize(s) Addressable::URI.parse(s.to_s).normalize.path end

      def build_query(params)
        params.map { |k, v|
          if v.class == Array
            build_query(v.map { |x| [k, x] })
          else
            v.nil? ? escape(k) : "#{escape(k)}=#{escape(v)}"
          end
        }.join("&")
      end

      def parse_query(query_string)
        return '' if query_string.nil? || query_string.empty?
        params = {}

        query_string.split(DEFAULT_QUERY_SEP).each do |part|
          k, v = part.split(KEY_VALUE_SEP, 2).map { |el| unescape(el) }

          if cur = params[k]
            if cur.class == Array
              params[k] << v
            else
              params[k] = [cur, v]
            end
          else
            params[k] = v
          end
        end
        params
      end

      def parse_query_for_param(query_string, name)
        parse_query(query_string).each do |key, val|
          return val.first if (name == key) && val.is_a?(Array)
          return val if (name == key)
        end
        return nil
      end

    end # Url
  end # Utils
end # Github
