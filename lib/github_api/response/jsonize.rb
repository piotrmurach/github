# encoding: utf-8

require 'faraday'
require 'github_api/jsonable'

module Github
  class Response::Jsonize < Response
    include Github::Jsonable

    dependency 'multi_json'

    define_parser do |body|
      Github::Jsonable.decode body
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
        self.class.parser.call body
      end
    end
  end # Response::Jsonize
end # Github
