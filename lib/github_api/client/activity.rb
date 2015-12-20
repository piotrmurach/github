# encoding: utf-8

module Github
  class Client::Activity < API

    require_all 'github_api/client/activity',
      'events',
      'notifications',
      'feeds',
      'starring',
      'watching'

    # Access to Activity::Events API
    namespace :events

    # Access to Activity::Notifications API
    namespace :notifications

    # Access to Activity::Feeds API
    namespace :feeds

    # Access to Activity::Starring API
    namespace :starring

    # Access to Activity::Watching API
    namespace :watching

  end # Activity
end # Github
