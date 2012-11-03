# encoding: utf-8

module Github
  class Activity::Notifications < API

    # Creates new Activity::Notifications API
    def initialize(options = {})
      super(options)
    end

    # List your notifications
    #
    # List all notifications for the current user, grouped by repository.
    #
    # = Parameters
    # * <tt>:all</tt> - Optional boolean - true to show notifications marked as read.
    # * <tt>:participating</tt> - Optional boolean - true to show only
    #                             notifications in which the user is directly
    #                             participating or mentioned.
    # * <tt>:since</tt> - Optional string - filters out any notifications updated
    #                     before the given time. The time should be passed in as
    #                     UTC in the ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    #                     Example: “2012-10-09T23:39:01Z”.
    #
    # = Examples
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.list
    #
    # List your notifications in a repository
    #
    # = Examples
    #  github = Github.new
    #  github.activity.notifications.list user: 'user-name', repo: 'repo-name'
    #
    def list(*args)
      params = args.extract_options!
      normalize! params
      filter! %w[ all participating since user repo], params

      response = if ( (user_name = params.delete("user")) &&
                      (repo_name = params.delete("repo")) )
        get_request("/repos/#{user_name}/#{repo_name}/notifications", params)
      else
        get_request("/notifications", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

  end # Activity::Notifications
end # Github
