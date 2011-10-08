# encoding: utf-8

module Github
  module VERSION
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = 'pre'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.');
  end
end
