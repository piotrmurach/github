require 'vcr'

VCR.config do |conf|
  conf.stub_with :webmock
  conf.cassette_library_dir = 'features/cassettes'
  conf.default_cassette_options = { :record => :new_episodes }
  conf.filter_sensitive_data('<***>') { ''}
end

VCR.cucumber_tags do |t|
  t.tag '@live', :record => :all
end
