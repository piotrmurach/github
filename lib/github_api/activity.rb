# encoding: utf-8

module Github
  class Activity < API
    extend AutoloadHelper

    autoload_all 'github_api/activity',
      :Notifications => 'notifications',
      :Starring      => 'starring'

    # Create new Activity API
    def initialize(options = {})
      super(options)
    end

    # Access to Activity::Notifications API
    def notifications
      @notifications ||= ApiFactory.new 'Activity::Notifications'
    end

    # Access to Activity::Starring API
    def starring
      @starring ||= ApiFactory.new 'Activity::Starring'
    end

  end # Activity
end # Github
