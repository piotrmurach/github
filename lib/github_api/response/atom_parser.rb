# encoding: utf-8

require 'faraday'

module Github
  class Response::AtomParser < Response
    define_parser do |body|
      require 'rss'
      RSS::Parser.parse(body)
    end

    def initialize(app, options = {})
      super(app, options.merge(content_type: /(\batom|\brss)/))
    end

    def on_complete(env)
      if parse_body?(env)
        process_body(env)
      end
    end
  end
end
