require File.expand_path('../lib/github/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'github'
  gem.description   = %q{ Ruby wrapper for the GitHub API v3}
  gem.homepage      = 'https://github.com/peter-murach/github'
  gem.require_paths = ['lib']
  gem.summary       = %q{ Ruby wrapper for the GitHub API v3}
  gem.version       = Github::VERSION.dup
end
