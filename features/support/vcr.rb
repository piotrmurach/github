require 'vcr'

VCR.configure do |conf|
  conf.hook_into :webmock
  conf.cassette_library_dir = 'features/cassettes'
  conf.default_cassette_options = { :record => :once }
  conf.filter_sensitive_data('<EMAIL>') { SETTINGS['email'] }
  conf.filter_sensitive_data('<TOKEN>') { SETTINGS['oauth_token'] }
  conf.filter_sensitive_data('<BASIC_AUTH>') { SETTINGS['basic_auth'] }
  conf.filter_sensitive_data('<USER>') { SETTINGS['user'] }
end

VCR.cucumber_tags do |t|
  t.tag '@live', :record => :all
end
