require File.expand_path('../lib/github/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'github-api'
  gem.authors       = [ "Piotr Murach" ]
  gem.email         = ""
  gem.homepage      = 'https://github.com/peter-murach/github'
  gem.require_paths = ['lib']
  gem.summary       = %q{ Ruby wrapper for the GitHub API v3}
  gem.description   = %q{ Ruby wrapper for the GitHub API v3}
  gem.version       = Github::Version::STRING.dup

  gem.files = `git ls-files`.split("\n")
  gem.require_paths = %w[ lib ]

  gem.add_dependency 'hashie', '~> 1.1.0'
  gem.add_dependency 'faraday', '~> 0.7.4'
  gem.add_dependency 'multi_json', '~> 1.0.3'
  gem.add_dependency 'oauth2', '~> 0.5.0'

  gem.add_development_dependency 'rspec', '~> 2.4.0' 
  gem.add_development_dependency 'cucumber', '>= 0'
  gem.add_development_dependency 'bundler', '~> 1.0.0'
  gem.add_development_dependency 'jeweler', '~> 1.6.4'
  gem.add_development_dependency 'webmock', '~> 1.7.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
end
