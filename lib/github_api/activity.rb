# encoding: utf-8

module Github
  class Activity < API
    extend AutoloadHelper

    autoload_all 'github_api/activity',
      :Events        => 'events',
      :Notifications => 'notifications',
      :Starring      => 'starring',
      :Watching      => 'watching'

    # Create new Activity API
    def initialize(options = {})
      super(options)
    end

    # Access to Activity::Events API
    def events(options = {})
      @events ||= ApiFactory.new 'Activity::Events', options
    end

    # Access to Activity::Notifications API
    def notifications
      @notifications ||= ApiFactory.new 'Activity::Notifications'
    end

    # Access to Activity::Starring API
    def starring
      @starring ||= ApiFactory.new 'Activity::Starring'
    end

    # Access to Activity::Watching API
    def watching
      @watching ||= ApiFactory.new 'Activity::Watching'
    end

  end # Activity
end # Github
