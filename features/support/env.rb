require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../spec')

if RUBY_VERSION > '1.9' and ENV['COVERAGE']
  require 'coverage_adapter'
  SimpleCov.start 'github_api'
  SimpleCov.coverage_dir 'coverage/cucumber'
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'github_api'

require 'rspec/expectations'
