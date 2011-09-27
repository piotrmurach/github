require File.expand_path('../lib/github/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'hashie', '~> 1.1.0'
  gem.add_dependency 'faraday', '~> 0.7.4'

  gem.name          = 'github'
  gem.authors       = [ "Piotr Murach" ]
  gem.description   = %q{ Ruby wrapper for the GitHub API v3}
  gem.homepage      = 'https://github.com/peter-murach/github'
  gem.require_paths = ['lib']
  gem.summary       = %q{ Ruby wrapper for the GitHub API v3}
  gem.version       = Github::Version::STRING.dup
end
