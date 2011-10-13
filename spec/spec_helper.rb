require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'webmock/rspec'
require 'github_api'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include WebMock::API
end

def stub_get(path, endpoint = Github.endpoint)
  stub_request(:get, endpoint + path)
end

def stub_post(path, endpoint = Github.endpoint)
  stub_request(:post, endpoint + path)
end

def stub_patch(path, endpoint = Github.endpoint)
  stub_request(:patch, endpoint + path)
end

def stub_put(path, endpoint = Github.endpoint)
  stub_request(:put, endpoint + path)
end

def stub_delete(path, endpoint = Github.endpoint)
  stub_request(:delete, endpoint + path)
end

def a_get(path, endpoint = Github.endpoint)
  a_request(:get, endpoint + path)
end

def a_post(path, endpoint = Github.endpoint)
  a_request(:post, endpoint + path)
end

def a_patch(path, endpoint = Github.endpoint)
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
