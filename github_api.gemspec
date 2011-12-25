require File.expand_path('../lib/github_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'github_api'
  gem.authors       = [ "Piotr Murach" ]
  gem.email         = ""
  gem.homepage      = 'https://github.com/peter-murach/github'
  gem.summary       = %q{ Ruby wrapper for the GitHub API v3}
  gem.description   = %q{ Ruby wrapper that supports all of the GitHub API v3 methods(nearly 200). It's build in a modular way, that is, you can either instantiate the whole api wrapper Github.new or use parts of it e.i. Github::Repos.new if working solely with repositories is your main concern. }
  gem.version       = Github::VERSION::STRING.dup

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_dependency 'hashie', '~> 1.2.0'
  gem.add_dependency 'faraday', '~> 0.7.4'
  gem.add_dependency 'multi_json', '~> 1.0.3'
  gem.add_dependency 'oauth2', '~> 0.5.0'

  gem.add_development_dependency 'rspec', '~> 2.7.0'
  gem.add_development_dependency 'cucumber', '>= 0'
  gem.add_development_dependency 'yajl-ruby', '~> 1.1.0'
  gem.add_development_dependency 'bundler', '~> 1.0.0'
  gem.add_development_dependency 'jeweler', '~> 1.6.4'
  gem.add_development_dependency 'webmock', '~> 1.7.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-cucumber'
end
