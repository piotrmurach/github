require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'json'
require 'webmock/rspec'
require 'github_api'

if RUBY_VERSION > '1.9' and ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/features/"
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include WebMock::API
end

def stub_get(path, endpoint = Github.endpoint.to_s)
  stub_request(:get, endpoint + path)
end

def stub_post(path, endpoint = Github.endpoint.to_s)
  stub_request(:post, endpoint + path)
end

def stub_patch(path, endpoint = Github.endpoint.to_s)
  stub_request(:patch, endpoint + path)
end

def stub_put(path, endpoint = Github.endpoint.to_s)
  stub_request(:put, endpoint + path)
end

def stub_delete(path, endpoint = Github.endpoint.to_s)
  stub_request(:delete, endpoint + path)
end

def a_get(path, endpoint = Github.endpoint.to_s)
  a_request(:get, endpoint + path)
end

def a_post(path, endpoint = Github.endpoint.to_s)
  a_request(:post, endpoint + path)
end

def a_patch(path, endpoint = Github.endpoint.to_s)
  a_request(:patch, endpoint + path)
end

def a_put(path, endpoint = Github.endpoint)
  a_request(:put, endpoint + path)
end

def a_delete(path, endpoint = Github.endpoint)
  a_request(:delete, endpoint + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(File.join(fixture_path, '/', file))
end

OAUTH_TOKEN = 'bafec72922f31fe86aacc8aca4261117f3bd62cf'

def reset_authentication_for(object)
  ['basic_auth', 'oauth_token', 'login', 'password' ].each do |item|
    object.send("#{item}=", nil)
  end
end

class Hash
  def except(*keys)
    cpy = self.dup
    keys.each { |key| cpy.delete(key) }
    cpy
  end
end
