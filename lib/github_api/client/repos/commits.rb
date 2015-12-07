# encoding: utf-8

module Github
  class Client::Repos::Commits < API

    VALID_COMMITS_OPTIONS = %w[
      sha
      path
      author
      since
      until
    ].freeze

    # List commits on a repository
    #
    # @param [Hash] params
    # @option params [String] :sha
    #   Sha or branch to start listing commits from.
    # @option params [String] :path
    #   Only commits containing this file path will be returned.
    # @option params [String] :author
    #   GitHub login, name or email by which to filter by commit author.
    # @option params [String] :since
    #   Only commits after this date will be returned. This is a timestamp
    #   in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    # @option params [String] :until
    #   Only commits before this date will be returned. This is a timestamp
    #   in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    #
    # @example
    #  github = Github.new
    #  github.repos.commits.list 'user-name', 'repo-name', sha: '...'
    #  github.repos.commits.list 'user-name', 'repo-name', sha: '...' { |commit| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_COMMITS_OPTIONS
      end

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/commits", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Gets a single commit
    #
    # @example
    #  github = Github.new
    #  github.repos.commits.get 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed6'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :sha])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/commits/#{arguments.sha}", arguments.params)
    end
    alias :find :get

    # Compares two commits
    #
    # @note Both :base and :head can be either branch names in :repo or
    # branch names in other repositories in the same network as :repo.
    # For the latter case, use the format user:branch:
    #
    # @example
    #  github = Github.new
    #  github.repos.commits.compare 'user-name', 'repo-name', 'v0.4.8', 'master'
    #
    # @api public
    def compare(*args)
      arguments(args, required: [:user, :repo, :base, :head])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/compare/#{arguments.base}...#{arguments.head}", arguments.params)
    end
  end # Client::Repos::Commits
end # Github
