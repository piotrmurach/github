# encoding: utf-8

require 'faraday'
require 'hashie'
require 'github_api/mash'

module Github
  class Response::Mashify < Response
    define_parser do |body|
      ::Github::Mash.new body
    end

    def parse(body)
      case body
      when Hash
        self.class.parser.call body
      when Array
        body.map { |item| item.is_a?(Hash) ? self.class.parser.call(item) : item }
      else
        body
      end
    end
  end # Response::Mashify
end # Github
