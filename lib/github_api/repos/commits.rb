# encoding: utf-8

module Github
  class Repos::Commits < API

    # List commits on a repository
    #
    # = Parameters
    # * <tt>:sha</tt>     Optional string. Sha or branch to start listing commits from.
    # * <tt>:path</tt>    Optional string. Only commits containing this file path will be returned.
    # * <tt>:author</tt>  GitHub login, name, or email by which to filter by commit author.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.commits.list 'user-name', 'repo-name', :sha => '...'
    #  github.repos.commits.list 'user-name', 'repo-name', :sha => '...' { |commit| ... }
    #
    def list(user_name, repo_name, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo
      normalize! params
      filter! %w[sha path author], params

      response = get_request("/repos/#{user}/#{repo}/commits", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Gets a single commit
    #
    # = Examples
    #  github = Github.new
    #  github.repos.commits.get 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed6')
    #
    def get(user_name, repo_name, sha, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, sha
      normalize! params

      get_request("/repos/#{user}/#{repo}/commits/#{sha}", params)
    end
    alias :find :get

    # Compares two commits
    #
    # = Examples
    #  github = Github.new
    #  github.repos.commits.compare
    #    'user-name',
    #    'repo-name',
    #    'v0.4.8',
    #    'master'
    #
    def compare(user_name, repo_name, base, head, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of base, head
      normalize! params

      get_request("/repos/#{user_name}/#{repo_name}/compare/#{base}...#{head}", params)
    end

  end # Repos::Commits
end # Github
