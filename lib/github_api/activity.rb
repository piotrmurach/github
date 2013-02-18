# encoding: utf-8

module Github
  class Activity < API
    extend AutoloadHelper

    autoload_all 'github_api/activity',
      :Events        => 'events',
      :Notifications => 'notifications',
      :Starring      => 'starring',
      :Watching      => 'watching'

    # Access to Activity::Events API
    def events(options={}, &block)
      @events ||= ApiFactory.new('Activity::Events', current_options.merge(options), &block)
    end

    # Access to Activity::Notifications API
    def notifications(options={}, &block)
      @notifications ||= ApiFactory.new('Activity::Notifications', current_options.merge(options), &block)
    end

    # Access to Activity::Starring API
    def starring(options={}, &block)
      @starring ||= ApiFactory.new('Activity::Starring', current_options.merge(options), &block)
    end

    # Access to Activity::Watching API
    def watching(options={}, &block)
      @watching ||= ApiFactory.new('Activity::Watching', current_options.merge(options), &block)
    end

  end # Activity
end # Github
