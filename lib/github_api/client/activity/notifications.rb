# encoding: utf-8

module Github
  class Client::Activity::Notifications < API
    # List your notifications
    #
    # List all notifications for the current user, grouped by repository.
    #
    # @see https://developer.github.com/v3/activity/notifications/#list-your-notifications
    #
    # @param [Hash] params
    # @option params [Boolean] :all
    #   If true, show notifications marked as read.
    #   Default: false
    # @option params [Boolean] :participating
    #   If true, only shows notifications in which the user
    #   is directly participating or mentioned. Default: false
    # @option params [String] :since
    #   Filters out any notifications updated before the given time.
    #   This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    #   Default: Time.now
    #
    # @example
    #   github = Github.new oauth_token: 'token'
    #   github.activity.notifications.list
    #
    # List your notifications in a repository
    #
    # @see https://developer.github.com/v3/activity/notifications/#list-your-notifications-in-a-repository
    #
    # @example
    #  github = Github.new
    #  github.activity.notifications.list user: 'user-name', repo: 'repo-name'
    #
    # @api public
    def list(*args)
      arguments(args)
      params = arguments.params

      response = if ( (user_name = params.delete('user')) &&
                      (repo_name = params.delete('repo')) )
        get_request("/repos/#{user_name}/#{repo_name}/notifications", params)
      else
        get_request('/notifications', params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # View a single thread
    #
    # @see https://developer.github.com/v3/activity/notifications/#view-a-single-thread
    #
    # @example
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.get 'thread_id'
    #  github.activity.notifications.get 'thread_id' { |thread| ... }
    #
    # @api public
    def get(*args)
      arguments(args, required: [:thread_id])

      response = get_request("/notifications/threads/#{arguments.thread_id}", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :find, :get

    # Mark as read
    #
    # Marking a notification as “read” removes it from the default view on GitHub.com.
    #
    # @see https://developer.github.com/v3/activity/notifications/#mark-as-read
    #
    # @param [Hash] params
    # @option params [String] :last_read_at
    #   Describes the last point that notifications were checked.
    #   Anything updated since this time will not be updated.
    #   This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    #   Default: Time.now
    #
    # @example
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.mark
    #
    # Mark notifications as read in a repository
    #
    # @see https://developer.github.com/v3/activity/notifications/#mark-notifications-as-read-in-a-repository
    #
    # @example
    #  github.activity.notifications.mark user: 'user-name', repo: 'repo-name'
    #
    # Mark a thread as read
    #
    # @see https://developer.github.com/v3/activity/notifications/#mark-a-thread-as-read
    #
    # @example
    #  github.activity.notifications.mark id: 'thread-id'
    #
    # @api public
    def mark(*args)
      arguments(args)
      params = arguments.params

      if ( (user_name = params.delete('user')) &&
           (repo_name = params.delete('repo')) )

        put_request("/repos/#{user_name}/#{repo_name}/notifications", params)
      elsif (thread_id = params.delete("id"))
        patch_request("/notifications/threads/#{thread_id}", params)
      else
        put_request('/notifications', params)
      end
    end

    # Check to see if the current user is subscribed to a thread.
    #
    # @see https://developer.github.com/v3/activity/notifications/#get-a-thread-subscription
    #
    # @example
    #  github = Github.new oauth_token: 'token'
    #  github.activity.notifications.subscribed? 'thread-id'
    #
    # @example
    #   github.activity.notifications.subscribed? id: 'thread-id'
    #
    # @api public
    def subscribed?(*args)
      arguments(args, required: [:thread_id])

      get_request("/notifications/threads/#{arguments.thread_id}/subscription", arguments.params)
    end

    # Create a thread subscription
    #
    # This lets you subscribe to a thread, or ignore it. Subscribing to a thread
    # is unnecessary if the user is already subscribed to the repository. Ignoring
    # a thread will mute all future notifications (until you comment or get
    # @mentioned).
    #
    # @see https://developer.github.com/v3/activity/notifications/#set-a-thread-subscription
    #
    # @param [Hash] params
    # @option params [Boolean] :subscribed
    #   Determines if notifications should be received from this thread
    # @option params [Boolean] :ignored
    #   Determines if all notifications should be blocked from this thread
    #
    # @example
    #   github = Github.new oauth_token: 'token'
    #   github.activity.notifications.create 'thread-id',
    #     subscribed: true
    #     ignored: false
    #
    # @api public
    def create(*args)
      arguments(args, required: [:thread_id])

      put_request("/notifications/threads/#{arguments.thread_id}/subscription", arguments.params)
    end

    # Delete a thread subscription
    #
    # @see https://developer.github.com/v3/activity/notifications/#delete-a-thread-subscription
    #
    # @example
    #   github = Github.new oauth_token: 'token'
    #   github.activity.notifications.delete 'thread_id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:thread_id])

      delete_request("/notifications/threads/#{arguments.thread_id}/subscription", arguments.params)
    end
    alias_method :remove, :delete
  end # Client::Activity::Notifications
end # Github
