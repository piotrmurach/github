# encoding: utf-8

module Github
  # Repository Starring is a feature that lets users bookmark repositories.
  # Stars are shown next to repositories to show an approximate level of interest.  # Stars have no effect on notifications or the activity feed.
  class Activity::Starring < API

    # List stargazers
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.activity.starring.list
    #  github.activity.starring.list { |star| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/repos/#{user}/#{repo}/stargazers", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List repos being starred by a user
    #
    # = Examples
    #  github = Github.new
    #  github.activity.starring.starred :user => 'user-name'
    #
    # List repos being starred by the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.activity.starring.starred
    #
    def starred(*args)
      params = arguments(args).params

      response = if (user_name = params.delete('user'))
        get_request("/users/#{user_name}/starred", params)
      else
        get_request("/user/starred", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if you are starring a repository
    #
    # Returns <tt>true</tt> if this repo is starred by you,<tt>false</tt> otherwise
    #
    # = Examples
    #  github = Github.new
    #  github.activity.starring.starring? 'user-name', 'repo-name'
    #
    def starring?(*args)
      arguments(args, :required => [:user, :repo])

      get_request("/user/starred/#{user}/#{repo}", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Star a repository
    #
    # You need to be authenticated to star a repository
    #
    # = Examples
    #  github = Github.new
    #  github.activity.starring.star 'user-name', 'repo-name'
    #
    def star(*args)
      arguments(args, :required => [:user, :repo])

      put_request("/user/starred/#{user}/#{repo}", arguments.params)
    end

    # Unstar a repository
    #
    # You need to be authenticated to unstar a repository.
    #
    # = Examples
    #  github = Github.new
    #  github.activity.starring.unstar 'user-name', 'repo-name'
    #
    def unstar(*args)
      arguments(args, :required => [:user, :repo])

      delete_request("/user/starred/#{user}/#{repo}", arguments.params)
    end

  end # Activity::Starring
end # Github
