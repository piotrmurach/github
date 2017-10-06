# encoding: utf-8

require_relative '../../api'

module Github
  class Client::Repos::Branches < API
    require_all 'github_api/client/repos/branches', 'protections'

    # Access to Repos::Branches::Protections API
    namespace :protections

    # List branches
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.list 'user-name', 'repo-name'
    #   github.repos(user: 'user-name', repo: 'repo-name').branches.list
    #
    # @example
    #   repos = Github::Repos.new
    #   repos.branches.list 'user-name', 'repo-name'
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/branches", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get branch
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.get 'user-name', 'repo-name', 'branch-name'
    #   github.repos.branches.get user: 'user-name', repo: 'repo-name', branch: 'branch-name'
    #   github.repos(user: 'user-name', repo: 'repo-name', branch: 'branch-name').branches.get
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :branch])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/branches/#{arguments.branch}", arguments.params)
    end
    alias :find :get
  end # Client::Repos::Branches
end # Github
