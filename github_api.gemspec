# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/github_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'github_api'
  gem.authors       = [ "Piotr Murach" ]
  gem.email         = ""
  gem.homepage      = 'https://github.com/peter-murach/github'
  gem.summary       = %q{ Ruby wrapper for the GitHub API v3}
  gem.description   = %q{ Ruby wrapper that supports all of the GitHub API v3 methods(nearly 200). It's build in a modular way, that is, you can either instantiate the whole api wrapper Github.new or use parts of it e.i. Github::Repos.new if working solely with repositories is your main concern. }
  gem.version       = Github::VERSION::STRING.dup

  gem.files = Dir['Rakefile', '{features,lib,spec}/**/*', 'README*', 'LICENSE*']
  gem.require_paths = %w[ lib ]

  gem.add_dependency 'hashie', '~> 1.2.0'
  gem.add_dependency 'faraday', '~> 0.7.6'
  gem.add_dependency 'multi_json', '~> 1.1.0'
  gem.add_dependency 'oauth2', '~> 0.5.2'

  gem.add_development_dependency 'rspec', '~> 2.8.0'
  gem.add_development_dependency 'cucumber', '>= 0'
  gem.add_development_dependency 'yajl-ruby', '~> 1.1.0'
  gem.add_development_dependency 'webmock', '~> 1.8.0'
  gem.add_development_dependency 'vcr', '~> 2.0.0'
  gem.add_development_dependency 'simplecov', '~> 0.6.1'
  gem.add_development_dependency 'guard', '~> 0.8.8'
  gem.add_development_dependency 'guard-rspec', '0.5.7'
  gem.add_development_dependency 'guard-cucumber', '0.7.4'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
end
