# encoding: utf-8

module Github
  # Watching a Repository registers the user to receive notificactions on new
  # discussions, as well as events in the user’s activity feed.
  class Repos::Watching < API

    # List repo watchers
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.repos.watching.list
    #  github.repos.watching.list { |watcher| ... }
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/subscribers", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List repos being watched by a user
    #
    # = Examples
    #  github = Github.new
    #  github.repos.watching.watched :user => 'user-name'
    #
    # List repos being watched by the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.repos.watching.watched
    #
    def watched(*args)
      params = args.extract_options!
      normalize! params

      response = if (user_name = params.delete('user'))
        get_request("/users/#{user_name}/subscriptions", params)
      else
        get_request("/user/subscriptions", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if you are watching a repository
    #
    # Returns <tt>true</tt> if this repo is watched by you, <tt>false</tt> otherwise
    # = Examples
    #  github = Github.new
    #  github.repos.watching.watching? 'user-name', 'repo-name'
    #
    def watching?(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      normalize! params
      get_request("/user/subscriptions/#{user_name}/#{repo_name}", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Watch a repository
    #
    # You need to be authenticated to watch a repository
    #
    # = Examples
    #  github = Github.new
    #  github.repos.watching.watch 'user-name', 'repo-name'
    #
    def watch(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      normalize! params
      put_request("/user/subscriptions/#{user_name}/#{repo_name}", params)
    end

    # Stop watching a repository
    #
    # You need to be authenticated to stop watching a repository.
    # = Examples
    #  github = Github.new
    #  github.repos.watching.unwatch 'user-name', 'repo-name'
    #
    def unwatch(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      normalize! params
      delete_request("/user/subscriptions/#{user_name}/#{repo_name}", params)
    end

  end # Repos::Watching
end # Github
