# encoding: utf-8

require 'faraday'
require 'json'

module Github
  class Response::Jsonize < Response

    dependency 'json'

    define_parser do |body|
      JSON.parse(body)
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
  end # Response::Jsonize
end # Github
