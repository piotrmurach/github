# encoding: utf-8

module Github
  class Gists < API
    extend AutoloadHelper
    
    autoload_all 'github/gists', 
      :Comments => 'comments'
    
    # Creates new Gists API
    def initialize(options = {})
      super(options)
    end

  end # Gists
end # Github
