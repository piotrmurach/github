require File.expand_path('../lib/github/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'hashie', '~> 1.1.0'
  gem.add_dependency 'faraday', '~> 0.7.4'
  gem.add_dependency 'multi_json', '~> 1.0.3'
  gem.add_dependency 'oauth2', '~> 0.5.0'

  gem.add_development_dependency 'rspec', '~> 2.4.0' 
  gem.add_development_dependency 'cucumber', '>= 0'
  gem.add_development_dependency 'bundler', '~> 1.0.0'
  gem.add_development_dependency 'jeweler', '~> 1.6.4'
  gem.add_development_dependency 'simplecov', '~> 0.4'

  gem.name          = 'github'
  gem.authors       = [ "Piotr Murach" ]
  gem.description   = %q{ Ruby wrapper for the GitHub API v3}
  gem.email         = ""
  gem.homepage      = 'https://github.com/peter-murach/github'
  gem.require_paths = ['lib']
  gem.summary       = %q{ Ruby wrapper for the GitHub API v3}
  gem.version       = Github::Version::STRING.dup
end
