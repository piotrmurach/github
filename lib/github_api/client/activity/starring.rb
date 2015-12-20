# encoding: utf-8

module Github
  # Repository Starring is a feature that lets users bookmark repositories.
  # Stars are shown next to repositories to show an approximate level of interest.
  # Stars have no effect on notifications or the activity feed.
  class Client::Activity::Starring < API
    # List stargazers
    #
    # @see https://developer.github.com/v3/activity/starring/#list-stargazers
    #
    # @example
    #   github = Github.new
    #   github.activity.starring.list user: 'user-name', repo: 'repo-name'
    #   github.activity.starring.list user: 'user-name', repo: 'repo-name' { |star| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/stargazers", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # List repos being starred by a user
    #
    # @see https://developer.github.com/v3/activity/starring/#list-repositories-being-starred
    #
    # @param [Hash] params
    # @option params [String] :sort
    #   One of created (when the repository was starred) or
    #   updated (when it was last pushed to).
    #   Default: created
    # @option params [String] :direction
    #   One of asc (ascending) or desc (descending).
    #   Default: desc
    #
    # @example
    #   github = Github.new
    #   github.activity.starring.starred user: 'user-name'
    #
    # List repos being starred by the authenticated user
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.activity.starring.starred
    #
    # @api public
    def starred(*args)
      arguments(args)
      params = arguments.params

      response = if (user_name = params.delete('user'))
        get_request("/users/#{user_name}/starred", params)
      else
        get_request('/user/starred', params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if you are starring a repository
    #
    # @see https://developer.github.com/v3/activity/starring/#check-if-you-are-starring-a-repository
    #
    # @example
    #   github = Github.new
    #   github.activity.starring.starring? 'user-name', 'repo-name'
    #
    # @example
    #   github.activity.starring.starring? user: 'user-name', repo: 'repo-name'
    #
    # @return [Boolean]
    #   Returns true if this repo is starred by you, false otherwise.
    #
    # @api public
    def starring?(*args)
      arguments(args, required: [:user, :repo])

      get_request("/user/starred/#{arguments.user}/#{arguments.repo}", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Star a repository
    #
    # You need to be authenticated to star a repository
    #
    # @see https://developer.github.com/v3/activity/starring/#star-a-repository
    #
    # @example
    #   github = Github.new
    #   github.activity.starring.star 'user-name', 'repo-name'
    #
    # @example
    #   github.activity.starring.star user: 'user-name', repo: 'repo-name'
    #
    # @api public
    def star(*args)
      arguments(args, required: [:user, :repo])

      put_request("/user/starred/#{arguments.user}/#{arguments.repo}", arguments.params)
    end

    # Unstar a repository
    #
    # You need to be authenticated to unstar a repository.
    #
    # @see https://developer.github.com/v3/activity/starring/#unstar-a-repository
    #
    # @example
    #   github = Github.new
    #   github.activity.starring.unstar 'user-name', 'repo-name'
    #
    # @example
    #   github.activit.starring.unstar user: 'user-name', repo: 'repo-name'
    #
    # @api public
    def unstar(*args)
      arguments(args, required: [:user, :repo])

      delete_request("/user/starred/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
  end # Client::Activity::Starring
end # Github
