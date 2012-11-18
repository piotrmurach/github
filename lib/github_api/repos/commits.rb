# encoding: utf-8

module Github
  class Repos::Commits < API

    VALID_COMMIT_OPTIONS = %w[ sha path author since until ]

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
    def list(*args)
      arguments(self, :required => [:user, :repo]).parse *args do
        sift VALID_COMMIT_OPTIONS
      end
      params = arguments.params

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
    def get(*args)
      arguments(self, :required => [:user, :repo, :sha]).parse *args
      params = arguments.params

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
    def compare(*args)
      arguments(self, :required => [:user, :repo, :base, :head]).parse *args
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/compare/#{base}...#{head}", params)
    end

  end # Repos::Commits
end # Github
