# encoding: utf-8

module Github
  class Client::Issues::Events < API
    # List events for an issue
    #
    # @example
    #  github = Github.new
    #  github.issues.events.list 'user-name', 'repo-name',
    #    issue_number: 'issue-number'
    #
    # List events for a repository
    #
    # @example
    #  github = Github.new
    #  github.issues.events.list 'user-name', 'repo-name'
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params

      response = if (issue_number = params.delete('issue_number'))
        get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{issue_number}/events", params)
      else
        get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/events", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single event
    #
    # @example
    #  github = Github.new
    #  github.issues.events.get 'user-name', 'repo-name', 'event-id'
    #
    # @api public
    def get(*args)
      arguments(args, :required => [:user, :repo, :id])
      params = arguments.params

      get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/events/#{arguments.id}", params)
    end
    alias :find :get
  end # Issues::Events
end # Github
