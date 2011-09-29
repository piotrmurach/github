# encoding: utf-8

require 'github/configuration'
require 'github/connection'

module Github
  extend Configuration

  class << self
    # Alias for Github::Client.new
    #
    # @return [Github::Client]
    def new(options = {})
      Github::Client.new(options)
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

  module AutoloadHelper
    
    def autoload_all(prefix, options)
      options.each do |const_name, path|
        autoload const_name, File.join(prefix, path)
      end
    end
  end

  extend AutoloadHelper

  autoload_all 'github',
    :API      => 'api',
    :Client   => 'client',
    :Repos    => 'repos',
    :Request  => 'request',
    :Response => 'response',
    :Error    => 'error'

end # Github
