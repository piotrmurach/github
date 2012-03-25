# encoding: utf-8

module Github
  module VERSION
    MAJOR = 0
    MINOR = 5
    PATCH = 0
    BUILD = 'rc1'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.');
  end
end
