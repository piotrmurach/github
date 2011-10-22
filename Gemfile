source "http://rubygems.org"

gemspec

group :development, :test do
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl_notify', :require => false if RUBY_PLATFORM =~ /darwin/i
end
