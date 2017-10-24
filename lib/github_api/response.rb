# encoding: utf-8

require 'faraday'

module Github
  # Contains methods and attributes that act on the response returned from the 
  # request
  class Response < Faraday::Response::Middleware
    CONTENT_TYPE = 'Content-Type'.freeze

    class << self
      attr_accessor :parser
    end

    def self.define_parser(&block)
      @parser = block
    end

    def initialize(app, options = {})
      super(app)
      @content_types = Array(options[:content_type])
    end

    def process_body(env)
      env[:body] = parse(env[:body])
    end

    def parse_body?(env)
      parse_response_type?(response_type(env)) and parse_response?(env)
    end

    def response_type(env)
      type = env[:response_headers][CONTENT_TYPE].to_s
      type = type.split(';', 2).first if type.index(';')
      type
    end

    def parse_response_type?(type)
      @content_types.empty? || @content_types.any? { |pattern|
        pattern.is_a?(Regexp) ? type =~ pattern : type == pattern
      }
    end

    def parse_response?(env)
      env[:body].respond_to?(:to_str)
    end
  end # Response
end # Github
