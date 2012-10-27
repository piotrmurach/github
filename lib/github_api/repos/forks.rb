# encoding: utf-8

module Github
  class Repos::Forks < API

    # List repository forks
    #
    # = Parameters
    # * <tt>:sort</tt> - newest, oldest, watchers, default: newest
    #
    # = Examples
    #  github = Github.new
    #  github.repos.forks.list 'user-name', 'repo-name'
    #  github.repos.forks.list 'user-name', 'repo-name' { |fork| ... }
    #
    def list(user_name, repo_name, params = {})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/forks", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Create a fork for the authenticated user
    #
    # = Inputs
    # * <tt>:org</tt> - Optional string - the name of the service that is being called.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.forks.create 'user-name', 'repo-name',
    #    "org" =>  "github"
    #
    def create(user_name, repo_name, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo
      normalize! params
      filter! %w[ org ], params

      post_request("/repos/#{user}/#{repo}/forks", params)
    end

  end # Repos::Forks
end # Github
