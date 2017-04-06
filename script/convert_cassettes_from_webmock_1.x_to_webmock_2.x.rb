# converts URIs in vcr cassettes from uri-based basic auth
# to header-based basic auth to be compatible with webmock 2.0.
# it will create a basic auth header with an ERB tag
# to keep user and password be editable.
#
#   Authorization: Basic <%= Base64.encode64("user:password").chomp %>
#
# may not work if using VCR's filter_sensitive_data.
# in that case use https://gist.github.com/ujh/594c99385b6cbe92e32b1bbfa8578a45
#
# usage:
#
#   CASSETTES_PATH=features/cassettes bundle exec ruby script/convert_cassettes_from_webmock_1.x_to_webmock_2.x.rb
#
# should help resolve https://github.com/vcr/vcr/issues/570

require 'json'
require 'yaml'
require 'uri'
require 'pry'
require 'base64'

unless File.directory? ENV['CASSETTES_PATH']
  puts "Directory not found: #{ENV['CASSETTES_PATH']}"
  exit 1
end

HTTP_AUTH_MASK = '<BASIC_AUTH>'
DUMMY_HTTP_AUTH = 'foobarmostunique:foobazquxmostrighteous'

Dir["#{ENV['CASSETTES_PATH']}/**/*"].each do |path|
  converted = false

  next if File.directory? path

  if path.end_with?('.yml')
    format = :yaml
    cassette = YAML.load File.read path
  else
    format = :json
    cassette = JSON.parse File.read path
  end

  cassette['http_interactions'].each do |http_interaction|
    request = http_interaction['request']

    request['uri'].gsub!(HTTP_AUTH_MASK, DUMMY_HTTP_AUTH)

    uri     = URI.parse request['uri']

    next if uri.userinfo.nil?
    converted = true

    erb = "Basic <%= Base64.encode64(#{uri.userinfo.inspect}).chomp %>"
    request['headers']['Authorization'] = erb

    uri.userinfo = ''
    request['uri'] = uri.to_s.gsub('%3C', '<').gsub("%3E", '>')

    request['uri'].gsub!(DUMMY_HTTP_AUTH, HTTP_AUTH_MASK)

    http_interaction['request'] = request
  end

  File.open path, 'w' do |file|
    file.write format == :yaml ? cassette.to_yaml : cassette.to_json
    puts "Converted #{path}"
  end if converted
end
