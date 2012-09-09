# encoding: utf-8

module Github
  # Repository Starring is a feature that lets users bookmark repositories.
  # Stars are shown next to repositories to show an approximate level of interest.  # Stars have no effect on notifications or the activity feed.
  class Repos::Starring < API

    # List stargazers
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.repos.starring.list
    #  github.repos.starring.list { |star| ... }
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/stargazers", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List repos being starred by a user
    #
    # = Examples
    #  github = Github.new
    #  github.repos.starring.starred :user => 'user-name'
    #
    # List repos being starred by the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.repos.starring.starred
    #
    def starred(*args)
      params = args.extract_options!
      normalize! params

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
    #  github.repos.starring.starring? 'user-name', 'repo-name'
    #
    def starring?(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      normalize! params
      get_request("/user/starred/#{user_name}/#{repo_name}", params)
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
    #  github.repos.starring.star 'user-name', 'repo-name'
    #
    def star(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      normalize! params
      put_request("/user/starred/#{user_name}/#{repo_name}", params)
    end

    # Unstar a repository
    #
    # You need to be authenticated to unstar a repository.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.starring.unstar 'user-name', 'repo-name'
    #
    def unstar(user_name, repo_name, params={})
      _validate_presence_of user_name, repo_name
      normalize! params
      delete_request("/user/starred/#{user_name}/#{repo_name}", params)
    end

  end # Repos::Starring
end # Github
