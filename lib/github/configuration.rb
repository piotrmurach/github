module Github
  module Configuration
    
    
    DEFAULT_ENDPOINT = 'https://api.github.com/'.freeze

    def configure
      yield self
    end
  end
end
