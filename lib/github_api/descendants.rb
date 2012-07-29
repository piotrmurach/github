# encoding: utf-8

module Github
  module Descendants
    def descendants
      ObjectSpace.each_object(::Class).select { |klass| klass < self }
    end
  end
end
