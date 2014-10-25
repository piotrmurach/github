# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/github_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'github_api'
  gem.authors       = [ "Piotr Murach" ]
  gem.email         = ""
  gem.homepage      = 'http://peter-murach.github.io/github/'
  gem.summary       = %q{ Ruby client for the official GitHub API }
  gem.description   = %q{ Ruby client that supports all of the GitHub API methods. It's build in a modular way, that is, you can either instantiate the whole api wrapper Github.new or use parts of it e.i. Github::Client::Repos.new if working solely with repositories is your main concern. Intuitive query methods allow you easily call API endpoints. }
  gem.version       = Github::VERSION::STRING.dup

  gem.files = Dir['Rakefile', '{features,lib,spec}/**/*', 'README*', 'LICENSE*']
  gem.require_paths = %w[ lib ]

  gem.add_dependency 'addressable', '~> 2.3'
  gem.add_dependency 'hashie',      '>= 3.3'
  gem.add_dependency 'faraday',     '~> 0.8', '< 0.10'
  gem.add_dependency 'multi_json',  '>= 1.7.5', '< 2.0'
  gem.add_dependency 'oauth2'
  gem.add_dependency 'nokogiri',    '~> 1.6.3'
  gem.add_dependency 'descendants_tracker', '~> 0.0.4'

  gem.add_development_dependency 'bundler', '~> 1.5'
end
