require 'vcr'

VCR.configure do |conf|
  conf.hook_into :webmock
  conf.cassette_library_dir = 'features/cassettes'
  conf.default_cassette_options = {
    :record => ENV['TRAVIS'] ? :none : :once,
    :serialize_with => :json,
    :preserve_exact_body_bytes  => true,
    :decode_compressed_response => true
  }
  conf.filter_sensitive_data('<EMAIL>') { SETTINGS['email'] }
  conf.filter_sensitive_data('<TOKEN>') { SETTINGS['oauth_token'] }
  conf.filter_sensitive_data('<BASIC_AUTH>') { SETTINGS['basic_auth'] }
  conf.filter_sensitive_data('<USER>') { SETTINGS['user'] }
  conf.debug_logger = File.open('test.log', 'w')
end

VCR.cucumber_tags do |t|
  t.tag '@live', :record => :all
end
