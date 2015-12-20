# encoding: utf-8

module Github
  class Client::Activity::Events < API
    # List all public events
    #
    # @see https://developer.github.com/v3/activity/events/#list-public-events
    #
    # @example
    #  github = Github.new
    #  github.activity.events.public
    #  github.activity.events.public { |event| ... }
    #
    # @api public
    def public(*args)
      arguments(args)

      response = get_request("/events", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :public_events, :public
    alias_method :list_public, :public
    alias_method :list_public_events, :public

    # List all repository events for a given user
    #
    # @example
    #   github = Github.new
    #   github.activity.events.repository 'user-name', 'repo-name'
    #   github.activity.events.repository 'user-name', 'repo-name' { |event| ... }
    #
    # @example
    #   github.activity.events.repository user: 'user-name', repo: 'repo-name'
    #   github.activity.events.repository user: 'user-name', repo: 'repo-name' {|event| ... }
    #
    # @api public
    def repository(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/events", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :repos,                  :repository
    alias_method :repo_events,            :repository
    alias_method :repository_events,      :repository
    alias_method :list_repository_events, :repository

    # List all issue events for a given repository
    #
    # @example
    #   github = Github.new
    #   github.activity.events.issue 'user-name', 'repo-name'
    #   github.activity.events.issue 'user-name', 'repo-name' { |event| ... }
    #
    # @example
    #   github.activity.events.issue user: 'user-name', repo: 'repo-name'
    #   github.activity.events.issue user: 'user-name', repo: 'repo-name' { |event| ... }
    #
    # @api public
    def issue(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/events", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :issues,            :issue
    alias_method :issue_events,      :issue
    alias_method :list_issue_events, :issue

    # List all public events for a network of repositories
    #
    # @see https://developer.github.com/v3/activity/events/#list-public-events-for-a-network-of-repositories
    #
    # @example
    #   github = Github.new
    #   github.activity.events.network 'user-name', 'repo-name'
    #   github.activity.events.network 'user-name', 'repo-name' { |event| ... }
    #
    # @example
    #   github.activity.events.network user: 'user-name', repo: 'repo-name'
    #   github.activity.events.network user: 'user-name', repo: 'repo-name' { |event| ... }
    #
    # @api public
    def network(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/networks/#{arguments.user}/#{arguments.repo}/events", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :repo_network,                   :network
    alias_method :repository_network,             :network
    alias_method :list_repo_network_events,       :network
    alias_method :list_repository_network_events, :network

    # List all public events for an organization
    #
    # @see https://developer.github.com/v3/activity/events/#list-public-events-for-an-organization
    #
    # @example
    #   github = Github.new
    #   github.activity.events.org 'org-name'
    #   github.activity.events.org 'org-name' { |event| ... }
    #
    # @example
    #   github.activity.events.org name: 'org-name'
    #   github.activity.events.org name: 'org-name' { |event| ... }
    #
    # @api public
    def org(*args)
      arguments(args, required: [:name])

      response = get_request("/orgs/#{arguments.name}/events", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :organization,             :org
    alias_method :list_orgs,                :org
    alias_method :list_org_events,          :org
    alias_method :list_organization_events, :org

    # List all events that a user has received
    #
    # @see https://developer.github.com/v3/activity/events/#list-events-that-a-user-has-received
    #
    # These are events that you’ve received by watching repos
    # and following users. If you are authenticated as the given user,
    # you will see private events. Otherwise, you’ll only see public events.
    #
    # @example
    #   github = Github.new
    #   github.activity.events.received 'user-name'
    #   github.activity.events.received 'user-name' { |event| ... }
    #
    # List all public events that a user has received
    #
    # @see https://developer.github.com/v3/activity/events/#list-public-events-that-a-user-has-received
    #
    # @example
    #   github = Github.new
    #   github.activity.events.received 'user-name', public: true
    #   github.activity.events.received 'user-name', public: true { |event| ... }
    #
    # @api public
    def received(*args)
      arguments(args, required: [:user])
      params = arguments.params

      public_events = if params['public']
        params.delete('public')
        '/public'
      end

      response = get_request("/users/#{arguments.user}/received_events#{public_events}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :user_received,      :received
    alias_method :list_user_received, :received

    # List all events that a user has performed
    #
    # @see https://developer.github.com/v3/activity/events/#list-events-performed-by-a-user
    #
    # If you are authenticated as the given user, you will see your private
    # events. Otherwise, you’ll only see public events.
    #
    # @example
    #   github = Github.new
    #   github.activity.events.performed 'user-name'
    #   github.activity.events.performed 'user-name' { |event| ... }
    #
    # List all public events that a user has performed
    #
    # @see https://developer.github.com/v3/activity/events/#list-public-events-performed-by-a-user
    #
    # @example
    #   github = Github.new
    #   github.activity.events.performed 'user-name', public: true
    #   github.activity.events.performed 'user-name', public: true { |event| ... }
    #
    # @api public
    def performed(*args)
      arguments(args, required: [:user])
      params = arguments.params

      public_events = if params['public']
        params.delete('public')
        '/public'
      end

      response = get_request("/users/#{arguments.user}/events#{public_events}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :user_performed,      :performed
    alias_method :list_user_performed, :performed

    # List all events for an organization
    #
    # @see https://developer.github.com/v3/activity/events/#list-events-for-an-organization
    #
    # This is the user's organization dashboard. You must be authenticated
    # as the user to view this.
    #
    # @example
    #   github = Github.new
    #   github.activity.events.user_org 'user-name', 'org-name'
    #   github.activity.events.user_org 'user-name', 'org-name' { |event| ... }
    #
    # @example
    #   github.activity.events.user_org user: 'user-name', name: 'org-name'
    #   github.activity.events.user_org user: 'user-name', name: 'org-name' {|event| ...}
    #
    # @api public
    def user_org(*args)
      arguments(args, required: [:user, :name])

      response = get_request("/users/#{arguments.user}/events/orgs/#{arguments.name}", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :user_organization,             :user_org
    alias_method :list_user_org,                 :user_org
    alias_method :list_user_org_events,          :user_org
    alias_method :list_user_organization_events, :user_org
  end # Client::Activity::Events
end # Github
