source 'https://rubygems.org'

gemspec

# Rack 2.0.x doesn't work on < Ruby 2.2
gem 'rack', '< 2.0'
gem 'mime-types', '~> 3.0'

group :development do
  gem 'yard',     '~> 0.9.9'
  gem 'pry'
end

group :metrics do
  gem 'coveralls',      '~> 0.8.7', require: false
  gem 'simplecov',      '~> 0.14.1'
  gem 'yardstick',      '~> 0.9.9'
end
