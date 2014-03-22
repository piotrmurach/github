# encoding: utf-8

module Github
  class Client < API

    require_all 'github_api',
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
      'say',
      'scopes',
      'search',
      'users'

    # Serving up the ‘social’ in Social Coding™, the Activity APIs
    # provide access to notifications, subscriptions, and timelines.
    #
    namespace :activity, root: true

    namespace :emojis, root: true

    namespace :gists, root: true

    namespace :gitignore, root: true
    alias :git_ignore :gitignore

    # The Git Database API gives you access to read and write raw Git objects
    # to your Git database on GitHub and to list and update your references
    # (branch heads and tags).
    namespace :git_data, root: true
    alias :git :git_data

    namespace :issues, root: true

    namespace :markdown, root: true

    namespace :meta, root: true

    # An API for users to manage their own tokens. You can only access your own
    # tokens, and only through Basic Authentication.
    namespace :oauth, root: true, full_name: :authorizations
    alias :authorizations :oauth

    namespace :orgs, root: true
    alias :organizations :orgs

    namespace :pull_requests, root: true
    alias :pulls :pull_requests

    namespace :repos, root: true
    alias :repositories :repos

    namespace :octocat, root: true, full_name: 'say'

    namespace :scopes, root: true

    namespace :search, root: true

    # Many of the resources on the users API provide a shortcut for getting
    # information about the currently authenticated user.
    #
    namespace :users, root: true

  end # Client
end # Github
