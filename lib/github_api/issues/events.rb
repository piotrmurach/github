# encoding: utf-8

module Github
  class Issues::Events < API

    # List events for an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.events.list 'user-name', 'repo-name', issue_id: 'issue-id'
    #
    # List events for a repository
    #
    # = Examples
    #  github = Github.new
    #  github.issues.events.list 'user-name', 'repo-name'
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = if (issue_id = params.delete('issue_id'))
        get_request("/repos/#{user}/#{repo}/issues/#{issue_id}/events", params)
      else
        get_request("/repos/#{user}/#{repo}/issues/events", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single event
    #
    # = Examples
    #  github = Github.new
    #  github.issues.events.get 'user-name', 'repo-name', 'event-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :event_id])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/issues/events/#{event_id}", params)
    end
    alias :find :get

  end # Issues::Events
end # Github
