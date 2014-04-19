# encoding: utf-8

module Github
  class Client < API

    require_all 'github_api/client',
      'activity',
      'authorizations',
      'emojis',
      'gists',
      'gitignore',
      'git_data',
      'issues',
      'markdown',
      'meta',
      'orgs',
      'pull_requests',
      'users'

    require_all 'github_api',
      'repos',
      'say',
      'scopes',
      'search'

    # Serving up the ‘social’ in Social Coding™, the Activity APIs
    # provide access to notifications, subscriptions, and timelines.
    namespace :activity

    namespace :emojis

    namespace :gists

    namespace :gitignore
    alias :git_ignore :gitignore

    # The Git Database API gives you access to read and write raw Git objects
    # to your Git database on GitHub and to list and update your references
    # (branch heads and tags).
    namespace :git_data
    alias :git :git_data

    namespace :issues

    namespace :markdown

    namespace :meta

    # An API for users to manage their own tokens. You can only access your own
    # tokens, and only through Basic Authentication.
    namespace :oauth, full_name: :authorizations
    alias :authorizations :oauth

    namespace :orgs
    alias :organizations :orgs

    namespace :pull_requests
    alias :pulls :pull_requests

    namespace :repos, root: true
    alias :repositories :repos

    namespace :octocat, root: true, full_name: 'say'

    namespace :scopes, root: true

    namespace :search, root: true

    # Many of the resources on the users API provide a shortcut for getting
    # information about the currently authenticated user.
    namespace :users
  end # Client
end # Github
