module Github
  class Response::Mashify < Faraday::Response::Middleware
    dependency 'hashie/mash'

    class << self
      attr_accessor :mash_class
    end

    self.mash_class = ::Hashie::Mash

    def parse(body)
      case body
      when Hash
        self.class.mash_class.new(body)
      when Array
         
      else
        body
      end
    end
  end
end
