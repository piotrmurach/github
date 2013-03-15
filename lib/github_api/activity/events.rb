# encoding: utf-8

module Github
  class Activity::Events < API

    # List all public events
    #
    # = Examples
    #  github = Github.new
    #  github.activity.events.public
    #  github.activity.events.public { |event| ... }
    #
    def public(*args)
      arguments(args)

      response = get_request("/events", arguments.params)
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
    #  github.activity.events.repository 'user-name', 'repo-name'
    #  github.activity.events.repository 'user-name', 'repo-name' { |event| ... }
    #
    #  github.activity.events.repository user: 'user-name', repo: 'repo-name'
    #  github.activity.events.repository user: 'user-name', repo: 'repo-name' {|event| ... }
    #
    def repository(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/repos/#{user}/#{repo}/events", arguments.params)
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
    #  github.activity.events.issue 'user-name', 'repo-name'
    #  github.activity.events.issue 'user-name', 'repo-name' { |event| ... }
    #
    #  github.activity.events.issue user: 'user-name', repo: 'repo-name'
    #  github.activity.events.issue user: 'user-name', repo: 'repo-name' { |event| ... }
    #
    def issue(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

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
    #  github.activity.events.network 'user-name', 'repo-name'
    #  github.activity.events.network 'user-name', 'repo-name' { |event| ... }
    #
    #  github.activity.events.network user: 'user-name', repo: 'repo-name'
    #  github.activity.events.network user: 'user-name', repo: 'repo-name' { |event| ... }
    #
    def network(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/networks/#{user}/#{repo}/events", arguments.params)
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
    #  github.activity.events.org 'org-name'
    #  github.activity.events.org 'org-name' { |event| ... }
    #
    #  github.activity.events.org org: 'org-name'
    #  github.activity.events.org org: 'org-name' { |event| ... }
    #
    def org(*args)
      arguments(args, :required => [:org_name])

      response = get_request("/orgs/#{org_name}/events", arguments.params)
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
    #  github.activity.events.received 'user-name'
    #  github.activity.events.received 'user-name' { |event| ... }
    #
    # List all public events that a user has received
    #
    # = Examples
    #  github = Github.new
    #  github.activity.events.received 'user-name', :public => true
    #  github.activity.events.received 'user-name', :public => true { |event| ... }
    #
    def received(*args)
      arguments(args, :required => [:user])
      params = arguments.params

      public_events = if params['public']
        params.delete('public')
        '/public'
      end

      response = get_request("/users/#{user}/received_events#{public_events}", params)
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
    #  github.activity.events.performed 'user-name'
    #  github.activity.events.performed 'user-name' { |event| ... }
    #
    # List all public events that a user has performed
    #
    # = Examples
    #  github = Github.new
    #  github.activity.events.performed 'user-name', :public => true
    #  github.activity.events.performed 'user-name', :public => true { |event| ... }
    #
    def performed(*args)
      arguments(args, :required => [:user])
      params = arguments.params

      public_events = if params['public']
        params.delete('public')
        '/public'
      end

      response = get_request("/users/#{user}/events#{public_events}", params)
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
    #  github.activity.events.user_org 'user-name', 'org-name'
    #  github.activity.events.user_org 'user-name', 'org-name' { |event| ... }
    #
    #  github.activity.events.user_org user: 'user-name', org_name: 'org-name'
    #  github.activity.events.user_org user: 'user-name', org_name: 'org-name' {|event| ...}
    #
    def user_org(*args)
      arguments(args, :required => [:user, :org_name])
      params = arguments.params

      response = get_request("/users/#{user}/events/orgs/#{org_name}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :user_organization :user_org
    alias :list_user_org :user_org
    alias :list_user_org_events :user_org
    alias :list_user_organization_events :user_org

  end # Activity::Events
end # Github
