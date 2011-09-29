# encoding: utf-8

require 'faraday'

module Github
  # Contains methods and attributes that act on the response returned from the 
  # request
  class Response < Faraday::Response::Middleware
    
  end # Response
end
