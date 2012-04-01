# encoding: utf-8

module Github
  class Repos::Watching < API

    # List repo watchers
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.repos.watching.watchers
    #  github.repos.watching.watchers { |watcher| ... }
    #
    def watchers(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)

      response = get_request("/repos/#{user}/#{repo}/watchers", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

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
      params = args.last.is_a?(Hash) ? args.pop : {}
      _normalize_params_keys(params)
      _merge_user_into_params!(params) unless params.has_key?('user')

      response = if (user_name = params.delete('user'))
        get_request("/users/#{user_name}/watched", params)
      else
        get_request("/user/watched", params)
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
      _normalize_params_keys(params)
      get_request("/user/watched/#{user_name}/#{repo_name}", params)
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
    #  github.repos.watching.start_watching 'user-name', 'repo-name'
    #
    def start_watching(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      _normalize_params_keys(params)
      put_request("/user/watched/#{user_name}/#{repo_name}", params)
    end

    # Stop watching a repository
    #
    # You need to be authenticated to stop watching a repository.
    # = Examples
    #  github = Github.new
    #  github.repos.watching.start_watching 'user-name', 'repo-name'
    #
    def stop_watching(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      _normalize_params_keys(params)
      delete_request("/user/watched/#{user_name}/#{repo_name}", params)
    end

  end # Repos::Watching
end # Github
