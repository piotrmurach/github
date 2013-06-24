# encoding: utf-8

require 'multi_json'

module Github
  module Jsonable
    extend self

    def decode(*args)
      return unless args.first
      if MultiJson.respond_to?(:load)
        MultiJson.load *args
      else
        MultiJson.decode *args
      end
    end
  end
end
