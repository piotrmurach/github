# encoding: utf-8

require_relative '../../api'

module Github
  class Client::Issues::Assignees < API
    # Lists all the available assignees (owner + collaborators)
    # to which issues may be assigned.
    #
    # @example
    #  Github.issues.assignees.list 'owner', 'repo'
    #  Github.issues.assignees.list 'owner', 'repo' { |assignee| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:owner, :repo])

      response = get_request("/repos/#{arguments.owner}/#{arguments.repo}/assignees", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Check to see if a particular user is an assignee for a repository.
    #
    # @example
    #  Github.issues.assignees.check 'user', 'repo', 'assignee'
    #
    # @example
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.assignees.check 'assignee'
    #
    # @api public
    def check(*args)
      arguments(args, required: [:owner, :repo, :assignee])
      params = arguments.params

      get_request("/repos/#{arguments.owner}/#{arguments.repo}/assignees/#{arguments.assignee}",params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Add assignees to an issue
    #
    # @example
    #   github = Github.new
    #   github.issues.assignees.add 'user', 'repo', 'issue-number',
    #     'hubot', 'other_assignee', ...
    #
    # @api public
    def add(*args)
      arguments(args, required: [:user, :repo, :number])
      params = arguments.params
      params['data'] = { 'assignees' => arguments.remaining } unless arguments.remaining.empty?

      post_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{arguments.number}/assignees", params)
    end
    alias :<< :add

    # Remove a assignees from an issue
    #
    # @example
    #   github = Github.new
    #   github.issues.assignees.remove 'user', 'repo', 'issue-number',
    #     'hubot', 'other_assignee'
    #
    # @api public
    def remove(*args)
      arguments(args, required: [:user, :repo, :number])
      params = arguments.params
      params['data'] = { 'assignees' => arguments.remaining } unless arguments.remaining.empty?

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{arguments.number}/assignees", params)
    end
  end # Issues::Assignees
end # Github
