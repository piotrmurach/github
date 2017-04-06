source 'https://rubygems.org'

gemspec

# Rack 2.0.x doesn't work on < Ruby 2.2
gem 'rack', '< 2.0'

group :development do
  gem 'cucumber', '~> 2.1'
  gem 'rspec',    '~> 2.14.1'
  gem 'vcr',      '~> 3'
  gem 'webmock',  '~> 1.17.3'
  gem 'yard',     '~> 0.8.7'
  gem 'pry'
end

group :metrics do
  gem 'coveralls',      require: false
  gem 'tins',           '~> 1.6.0'
  gem 'term-ansicolor', '~>1.3.0'
  gem 'simplecov',      '~> 0.10.0'
  gem 'yardstick',      '~> 0.9.9'
end
