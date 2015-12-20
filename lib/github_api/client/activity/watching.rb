# encoding: utf-8

module Github
  # Watching a Repository registers the user to receive notificactions on new
  # discussions, as well as events in the user's activity feed.
  class Client::Activity::Watching < API
    # List repository watchers
    #
    # @see https://developer.github.com/v3/activity/watching/#list-watchers
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.list user: 'user-name', repo: 'repo-name'
    #   github.activity.watching.list user: 'user-naem', repo: 'repo-name' { |watcher| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/subscribers", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # List repos being watched by a user
    #
    # @see https://developer.github.com/v3/activity/watching/#list-repositories-being-watched
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.watched user: 'user-name'
    #
    # List repos being watched by the authenticated user
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.activity.watching.watched
    #
    # @api public
    def watched(*args)
      arguments(args)
      params = arguments.params

      response = if (user_name = params.delete('user'))
        get_request("/users/#{user_name}/subscriptions", params)
      else
        get_request('/user/subscriptions', params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if you are subscribed to a repository
    #
    # @see https://developer.github.com/v3/activity/watching/#get-a-repository-subscription
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.subscribed? 'user-name', 'repo-name'
    #
    # @example
    #   github.activity.watching.subscribed? user: 'user-name', repo: 'repo-name'
    #
    # @api public
    def subscribed?(*args)
      arguments(args, required: [:user, :repo])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/subscription", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Create subscription to a repository
    #
    # @see https://developer.github.com/v3/activity/watching/#set-a-repository-subscription
    #
    # @param [Hash] params
    # @option params [Boolean] :subscribed
    #   Determines if notifications should be received from this repository.
    # @option params [Boolean] :ignored
    #   Determines if all notifications should be blocked from this repository.
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.create 'user-name', 'repo-name'
    #
    # @example
    #   github.activity.watching.create user: 'user-name', repo: 'repo-name'
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo])

      put_request("/repos/#{arguments.user}/#{arguments.repo}/subscription", arguments.params)
    end
    alias_method :subscribe, :create

    # Delete a repository subscription
    #
    # @see https://developer.github.com/v3/activity/watching/#delete-a-repository-subscription
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.activity.watching.delete 'user-name', 'repo-name'
    #
    # @example
    #   github.activity.watching.delete user: 'user-name', repo: 'repo-name'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/subscription", arguments.params)
    end
    alias_method :unsubscribe, :delete

    # Check if you are watching a repository
    #
    # @see https://developer.github.com/v3/activity/watching/#check-if-you-are-watching-a-repository-legacy
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.watching? 'user-name', 'repo-name'
    #
    # @return [Boolean]
    #   Returns true if this repo is watched by you, false otherwise.
    #
    # @api public
    def watching?(*args)
      arguments(args, required: [:user, :repo])

      get_request("/user/subscriptions/#{arguments.user}/#{arguments.repo}", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Watch a repository
    #
    # You need to be authenticated to watch a repository
    #
    # @see https://developer.github.com/v3/activity/watching/#watch-a-repository-legacy
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.watch 'user-name', 'repo-name'
    #
    # @api public
    def watch(*args)
      arguments(args, required: [:user, :repo])

      put_request("/user/subscriptions/#{arguments.user}/#{arguments.repo}", arguments.params)
    end

    # Stop watching a repository
    #
    # You need to be authenticated to stop watching a repository.
    #
    # @see https://developer.github.com/v3/activity/watching/#stop-watching-a-repository-legacy
    #
    # @example
    #   github = Github.new
    #   github.activity.watching.unwatch 'user-name', 'repo-name'
    #
    # @api public
    def unwatch(*args)
      arguments(args, required: [:user, :repo])

      delete_request("/user/subscriptions/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
  end # Activity::Watching
end # Github
