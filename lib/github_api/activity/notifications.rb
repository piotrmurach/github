# encoding: utf-8

module Github
  class Activity::Notifications < API

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
      params = arguments(args) do
        sift %w[ all participating since user repo]
      end.params

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

    # View a single thread
    #
    # = Examples
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.get 'thread_id'
    #  github.activity.notifications.get 'thread_id' { |thread| ... }
    #
    def get(*args)
      arguments(args, :required => [:thread_id])

      response = get_request("/notifications/threads/#{thread_id}", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :find :get

    # Mark as read
    #
    # Marking a notification as “read” removes it from the default view on GitHub.com.
    #
    # = Parameters
    #
    # * <tt>:unread</tt> - boolean - Changes the unread status of the threads.
    # * <tt>:read</tt> - boolean - Inverse of "unread"
    # * <tt>:last_read_at</tt> - optional string time - describes the last point 
    #                            that notifications were checked. Anything updated 
    #                            since this time will not be updated. Default: Now.
    #                            Expected in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    #                            Example: “2012-10-09T23:39:01Z”.
    #
    # = Examples
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.mark read: true
    #
    # Mark notifications as read in a repository
    #
    # = Examples
    #  github.activity.notifications.mark user: 'user-name', repo: 'repo-name',
    #    read: true
    #
    # Mark a thread as read
    #
    # = Examples
    #  github.activity.notifications.mark thread_id: 'id', read: true
    #
    def mark(*args)
      params = arguments(args) do
        sift %w[ unread read last_read_at user repo thread_id]
      end.params

      if ( (user_name = params.delete("user")) &&
           (repo_name = params.delete("repo")) )

        put_request("/repos/#{user_name}/#{repo_name}/notifications", params)
      elsif (thread_id = params.delete("thread_id"))
        patch_request("/notifications/threads/#{thread_id}", params)
      else
        put_request("/notifications", params)
      end
    end

    # Check to see if the current user is subscribed to a thread.
    #
    # = Examples
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.subscribed? 'thread-id'
    #
    def subscribed?(*args)
      arguments(args, :required => [:thread_id])

      get_request("/notifications/threads/#{thread_id}/subscription", arguments.params)
    end

    # Create a thread subscription
    #
    # This lets you subscribe to a thread, or ignore it. Subscribing to a thread
    # is unnecessary if the user is already subscribed to the repository. Ignoring
    # a thread will mute all future notifications (until you comment or get
    # @mentioned).
    #
    # = Parameters
    # * <tt>:subscribed</tt> - boolean - determines if notifications should be
    #                          received from this thread.
    # * <tt>:ignored</tt> - boolean - deterimines if all notifications should be
    #                       blocked from this thread.
    # = Examples
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.create 'thread-id',
    #    'subscribed': true
    #    'ignored': false
    #
    def create(*args)
      arguments(args, :required => [:thread_id])

      put_request("/notifications/threads/#{thread_id}/subscription", arguments.params)
    end

    # Delete a thread subscription
    #
    # = Examples
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.delete 'thread_id'
    #
    def delete(*args)
      arguments(args, :required => [:thread_id])

      delete_request("/notifications/threads/#{thread_id}/subscription", arguments.params)
    end
    alias :remove :delete

  end # Activity::Notifications
end # Github
