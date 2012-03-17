# encoding: utf-8

module Github
  class Issues::Events < API

    # Creates new Issues::Events API
    def initialize(options = {})
      super(options)
    end

    # List events for an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.events.list 'user-name', 'repo-name', 'issue-id'
    #
    # List events for a repository
    #
    # = Examples
    #  github = Github.new
    #  github.issues.events.list 'user-name', 'repo-name'
    #
    def list(user_name, repo_name, issue_id=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)

      response = if issue_id
        get("/repos/#{user}/#{repo}/issues/#{issue_id}/events", params)
      else
        get("/repos/#{user}/#{repo}/issues/events", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single event
    #
    # = Examples
    #  github = Github.new
    #  github.issues.events.find 'user-name', 'repo-name', 'event-id'
    #
    def find(user_name, repo_name, event_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of event_id
      _normalize_params_keys(params)

      get("/repos/#{user}/#{repo}/issues/events/#{event_id}")
    end

  end # Issues::Events
end # Github
