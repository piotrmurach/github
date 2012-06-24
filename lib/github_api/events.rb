# encoding: utf-8

module Github
  class Events < API

    # Creates new Gists API
    def initialize(options = {})
      super(options)
    end

    # List all public events
    #
    # = Examples
    #  github = Github.new
    #  github.events.public
    #  github.events.public { |event| ... }
    #
    def public(params={})
      normalize! params

      response = get_request("/events", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :public_events :public
    alias :list_public :public
    alias :list_public_events :public

    # List all repository events for a given user
    #
    # = Examples
    #  github = Github.new
    #  github.events.repository 'user-name', 'repo-name'
    #  github.events.repository 'user-name', 'repo-name' { |event| ... }
    #
    def repository(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/events", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :repos :repository
    alias :repo_events :repository
    alias :repository_events :repository
    alias :list_repository_events :repository

    # List all issue events for a given repository
    #
    # = Examples
    #  github = Github.new
    #  github.events.issue 'user-name', 'repo-name'
    #  github.events.issue 'user-name', 'repo-name' { |event| ... }
    #
    def issue(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/issues/events", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :issues :issue
    alias :issue_events :issue
    alias :list_issue_events :issue

    # List all public events for a network of repositories
    #
    # = Examples
    #  github = Github.new
    #  github.events.network 'user-name', 'repo-name'
    #  github.events.network 'user-name', 'repo-name' { |event| ... }
    #
    def network(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/networks/#{user}/#{repo}/events", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :repo_network :network
    alias :repository_network :network
    alias :list_repo_network_events :network
    alias :list_repository_network_events :network

    # List all public events for an organization
    #
    # = Examples
    #  github = Github.new
    #  github.events.org 'org-name'
    #  github.events.org 'org-name' { |event| ... }
    #
    def org(org_name, params={})
      _validate_presence_of org_name
      normalize! params

      response = get_request("/orgs/#{org_name}/events", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :organization :org
    alias :list_orgs :org
    alias :list_org_events :org
    alias :list_organization_events :org

    # List all events that a user has received
    #
    # These are events that you’ve received by watching repos and following users.
    # If you are authenticated as the given user, you will see private events. 
    # Otherwise, you’ll only see public events.
    #
    # = Examples
    #  github = Github.new
    #  github.events.received 'user-name'
    #  github.events.received 'user-name' { |event| ... }
    #
    # List all public events that a user has received
    #
    # = Examples
    #  github = Github.new
    #  github.events.received 'user-name', :public => true
    #  github.events.received 'user-name', :public => true { |event| ... }
    #
    def received(user_name, params={})
      _validate_presence_of user_name
      normalize! params

      public_events = if params['public']
        params.delete('public')
        '/public'
      end

      response = get_request("/users/#{user_name}/received_events#{public_events}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :user_received :received
    alias :list_user_received :received

    # List all events that a user has performed
    #
    # If you are authenticated as the given user, you will see your private
    # events. Otherwise, you’ll only see public events.
    #
    # = Examples
    #  github = Github.new
    #  github.events.performed 'user-name'
    #  github.events.performed 'user-name' { |event| ... }
    #
    # List all public events that a user has performed
    #
    # = Examples
    #  github = Github.new
    #  github.events.performed 'user-name', :public => true
    #  github.events.performed 'user-name', :public => true { |event| ... }
    #
    def performed(user_name, params={})
      _validate_presence_of user_name
      normalize! params

      public_events = if params['public']
        params.delete('public')
        '/public'
      end

      response = get_request("/users/#{user_name}/events#{public_events}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :user_performed :performed
    alias :list_user_performed :performed

    # List all events for an organization
    #
    # This is the user’s organization dashboard. You must be authenticated
    # as the user to view this.
    #
    # = Examples
    #  github = Github.new
    #  github.events.user_org 'user-name', 'org-name'
    #  github.events.user_org 'user-name', 'org-name' { |event| ... }
    #
    def user_org(user_name, org_name, params={})
      _validate_presence_of user_name, org_name
      normalize! params

      response = get_request("/users/#{user_name}/events/orgs/#{org_name}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :user_organization :user_org
    alias :list_user_org :user_org
    alias :list_user_org_events :user_org
    alias :list_user_organization_events :user_org

  end # Events
end # Github
