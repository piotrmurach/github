source 'https://rubygems.org'

gemspec

group :guard do
  gem 'rb-fsevent',   :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl',        :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl_notify', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard',          '~> 1.8.1'
  gem 'guard-rspec',    '~> 3.0.2'
  gem 'guard-cucumber', '~> 1.4'
end

group :development do
  gem 'rake',     '~> 10.3'
  gem 'rspec',    '~> 2.14.1'
  gem 'cucumber', '~> 1.3'
  gem 'webmock',  '~> 1.17.3'
  gem 'vcr',      '~> 2.6'
  gem 'yard',     '~> 0.8.7'
end

group :metrics do
  gem 'coveralls', '~> 0.7.0'
  gem 'simplecov', '~> 0.8.2'
  gem 'yardstick', '~> 0.9.9'
  gem 'reek',      '~> 1.2.12'
  gem 'roodi',     '~> 2.2.0'
end
