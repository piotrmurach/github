# encoding: utf-8

require 'faraday'

module Github
  class Response::Xmlize < Response

    dependency 'nokogiri'

    define_parser do |body|
      ::Nokogiri::XML body
    end

    def parse(body)
      case body
      when ''
        nil
      when 'true'
        true
      when 'false'
        false
      else
        self.class.parser.call(body)
      end
    end
  end # Response::Xmlize
end # Github
