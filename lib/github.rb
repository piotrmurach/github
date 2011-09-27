module Github
  extend Configuration

  class << self
    # Alias for Github::Client.new
    #
    # @return [Github::Client]
    def new(options = {})
      Github::Client.new
    end
    
    # Delegate to Github::Client
    #
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end
    
    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private) 
    end
  end
end
