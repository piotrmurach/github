require 'simplecov'
require 'coveralls'

SimpleCov.adapters.define 'github_api' do
  add_filter "/spec/"
  add_filter "/features/"

  add_group 'Repos',   'lib/github_api/repos'
  add_group 'Orgs',    'lib/github_api/orgs'
  add_group 'Users',   'lib/github_api/users'
  add_group 'Issues',  'lib/github_api/issues'
  add_group 'Events',  'lib/github_api/events'
  add_group 'Gists',   'lib/github_api/gists'
  add_group 'Git Data','lib/github_api/git_data'
  add_group 'Pull Requests','lib/github_api/pull_requests'
end # SimpleCov
