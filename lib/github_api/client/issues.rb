# encoding: utf-8

module Github
  class Client::Issues < API

    require_all 'github_api/client/issues',
      'assignees',
      'comments',
      'events',
      'labels',
      'milestones'

    VALID_ISSUE_PARAM_NAMES = %w[
      assignee
      body
      creator
      direction
      filter
      labels
      milestone
      mentioned
      mime_type
      org
      resource
      since
      sort
      state
      title
    ].freeze

    VALID_ISSUE_PARAM_VALUES = {
      'filter'    => %w[ assigned created mentioned subscribed all ],
      'state'     => %w[ open closed all ],
      'sort'      => %w[ created updated comments ],
      'direction' => %w[ desc asc ],
      'since'     => %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z}
    }

    # Access to Issues::Assignees API
    namespace :assignees

    # Access to Issues::Comments API
    namespace :comments

    # Access to Issues::Events API
    namespace :events

    # Access to Issues::Comments API
    namespace :labels

    # Access to Issues::Comments API
    namespace :milestones

    # List your issues
    #
    # List all issues across all the authenticated user’s visible repositories
    # including owned repositories, member repositories,
    # and organization repositories.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.issues.list
    #
    # List all issues across owned and member repositories for the
    # authenticated user.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.issues.list :user
    #
    # List all issues for a given organization for the authenticated user.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.issues.list org: 'org-name'
    #
    # List issues for a repository
    #
    # @example
    #  github = Github.new
    #  github.issues.list user: 'user-name', repo: 'repo-name'
    #
    # @param [Hash] params
    # @option params [String] :filter
    #  * assigned   Issues assigned to you (default)
    #  * created    Issues created by you
    #  * mentioned  Issues mentioning you
    #  * subscribed Issues you've subscribed to updates for
    #  * all        All issues the user can see
    # @option params [String] :milestone
    #  * Integer Milestone number
    #  * none for Issues with no Milestone.
    #  * *    for Issues with any Milestone
    # @option params [String] :state
    #   open, closed, default: open
    # @option params [String] :labels
    #   String list of comma separated Label names. Example: bug,ui,@high
    # @option params [String] :assignee
    #  * String User login
    #  * <tt>none</tt> for Issues with no assigned User.
    #  * <tt>*</tt>    for Issues with any assigned User.
    # @option params [String] :creator
    #   String User login
    # @option params [String] :mentioned
    #   String User login
    # @option params [String] :sort
    #   created, updated, comments, default: <tt>created</tt>
    # @option params [String] :direction
    #   asc, desc, default: desc
    # @option params [String] :since
    #   Optional string of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.issues.list since: '2011-04-12T12:12:12Z',
    #    filter: 'created',
    #    state: 'open',
    #    labels: "bug,ui,bla",
    #    sort: 'comments',
    #    direction: 'asc'
    #
    # @api public
    def list(*args)
      params = arguments(args) do
        assert_values VALID_ISSUE_PARAM_VALUES
      end.params

      response = if (org = params.delete('org'))
        get_request("/orgs/#{org}/issues", params)

      elsif (user_name = params.delete('user')) &&
            (repo_name = params.delete('repo'))

        list_repo user_name, repo_name
      elsif args.include? :user
        get_request("/user/issues", params)
      else
        get_request("/issues", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List issues for a repository
    #
    # def list_repo(user_name, repo_name, params)
    def list_repo(user, repo)
      get_request("/repos/#{user}/#{repo}/issues", arguments.params)
    end
    private :list_repo

    # Get a single issue
    #
    # @example
    #  github = Github.new
    #  github.issues.get 'user-name', 'repo-name', 'number'
    #
    def get(*args)
      arguments(args, required: [:user, :repo, :number])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{arguments.number}", arguments.params)
    end
    alias :find :get

    # Create an issue
    #
    # @param [Hash] params
    # @option params [String] :title
    #   Required string
    # @option params [String] :body
    #   Optional string
    # @option params [String] :assignee
    #   Optional string - Login for the user that this issue should be
    #   assigned to. Only users with push access can set the assignee for
    #   new issues. The assignee is silently dropped otherwise.
    # @option params [Number] :milestone
    #   Optional number - Milestone to associate this issue with.
    #   Only users with push access can set the milestone for new issues.
    #   The milestone is silently dropped otherwise.
    # @option params [Array[String]] :labels
    #   Optional array of strings - Labels to associate with this issue
    #   Only users with push access can set labels for new issues.
    #   Labels are silently dropped otherwise.
    #
    # @example
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.create
    #    title: "Found a bug",
    #    body: "I'm having a problem with this.",
    #    assignee: "octocat",
    #    milestone: 1,
    #    labels: [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_ISSUE_PARAM_NAMES
        assert_required %w[ title ]
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/issues", arguments.params)
    end

    # Edit an issue
    #
    # @param [Hash] params
    # @option params [String] :title
    #   Optional string
    # @option params [String] :body
    #   Optional string
    # @option params [String] :assignee
    #   Optional string - Login for the user that this issue should be assigned to.
    # @option params [String] :state
    #   Optional string - State of the issue: open or closed
    # @option params [Number] :milestone
    #   Optional number - Milestone to associate this issue with
    # @option params [Array[String]] :labels
    #   Optional array of strings - Labels to associate with this issue.
    #   Pass one or more Labels to replace the set of Labels on this Issue.
    #   Send an empty array ([]) to clear all Labels from the Issue.
    #
    # @example
    #  github = Github.new
    #  github.issues.edit 'user-name', 'repo-name', 'number'
    #    title: "Found a bug",
    #    body: "I'm having a problem with this.",
    #    assignee: "octocat",
    #    milestone: 1,
    #    labels": [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:user, :repo, :number]) do
        permit VALID_ISSUE_PARAM_NAMES
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{arguments.number}", arguments.params)
    end
  end # Issues
end # Github
