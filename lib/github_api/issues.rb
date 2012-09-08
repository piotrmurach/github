# encoding: utf-8

module Github
  class Issues < API
    extend AutoloadHelper

    autoload_all 'github_api/issues',
      :Assignees  => 'assignees',
      :Comments   => 'comments',
      :Events     => 'events',
      :Labels     => 'labels',
      :Milestones => 'milestones'

    VALID_ISSUE_PARAM_NAMES = %w[
      filter
      state
      labels
      sort
      direction
      since
      milestone
      assignee
      mentioned
      title
      body
      resource
      mime_type
    ].freeze

    VALID_ISSUE_PARAM_VALUES = {
      'filter'    => %w[ assigned created mentioned subscribed ],
      'state'     => %w[ open closed ],
      'sort'      => %w[ created updated comments ],
      'direction' => %w[ desc asc ],
      'since'     => %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z}
    }

    # Creates new Issues API
    def initialize(options = {})
      super(options)
    end

    # Access to Issues::Assignees API
    def assignees
      @assignees ||= ApiFactory.new 'Issues::Assignees'
    end

    # Access to Issues::Comments API
    def comments
      @comments ||= ApiFactory.new 'Issues::Comments'
    end

    # Access to Issues::Events API
    def events
      @events ||= ApiFactory.new 'Issues::Events'
    end

    # Access to Issues::Comments API
    def labels
      @labels ||= ApiFactory.new 'Issues::Labels'
    end

    # Access to Issues::Comments API
    def milestones
      @milestones ||= ApiFactory.new 'Issues::Milestones'
    end

    # List your issues
    #
    # = Parameters
    # <tt>:filter</tt>
    #  * <tt>assigned</tt>: Issues assigned to you (default)
    #  * <tt>created</tt>: Issues assigned to you (default)
    #  * <tt>mentioned</tt>: Issues assigned to you (default)
    #  * <tt>subscribed</tt>: Issues assigned to you (default)
    # <tt>:state</tt> - <tt>open</tt>, <tt>closed</tt>, default: <tt>open</tt>
    # <tt>:labels</tt> - String list of comma separated Label names. Example: bug,ui,@high
    # <tt>:sort</tt> - <tt>created</tt>, <tt>updated</tt>, <tt>comments</tt>, default: <tt>created</tt>
    # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
    # <tt>:since</tt> - Optional string of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.issues.list :since => '2011-04-12T12:12:12Z',
    #    :filter => 'created',
    #    :state  => 'open',
    #    :labels => "bug,ui,bla",
    #    :sort   => 'comments',
    #    :direction => 'asc'
    #
    def list(*args)
      params = args.extract_options!
      normalize! params
      filter! VALID_ISSUE_PARAM_NAMES, params
      # _merge_mime_type(:issue, params)
      assert_valid_values(VALID_ISSUE_PARAM_VALUES, params)

      response = get_request("/issues", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List issues for a repository
    #
    # = Parameters
    # <tt>:milestone</tt>
    #  * Integer Milestone number
    #  * <tt>none</tt> for Issues with no Milestone.
    #  * <tt>*</tt> for Issues with any Milestone
    # <tt>:state</tt> - <tt>open</tt>, <tt>closed</tt>, default: <tt>open</tt>
    # <tt>:assignee</tt>
    #  * String User login
    #  * <tt>none</tt> for Issues with no assigned User.
    #  * <tt>*</tt> for Issues with any assigned User.
    # <tt>:mentioned</tt> String User login
    # <tt>:labels</tt> - String list of comma separated Label names. Example: bug,ui,@high
    # <tt>:sort</tt> - <tt>created</tt>, <tt>updated</tt>, <tt>comments</tt>, default: <tt>created</tt>
    # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
    # <tt>:since</tt> - Optional string of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ
    # <tt></tt>, default: <tt>due_date</tt>
    # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.issues.list_repo :milestone => 1,
    #    :state  => 'open',
    #    :assignee => '*',
    #    :mentioned => 'octocat',
    #    :labels => "bug,ui,bla",
    #    :sort   => 'comments',
    #    :direction => 'asc'
    #
    def list_repo(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      normalize! params
      filter! VALID_ISSUE_PARAM_NAMES, params
      # _merge_mime_type(:issue, params)
      assert_valid_values(VALID_ISSUE_PARAM_VALUES, params)

      response = get_request("/repos/#{user}/#{repo}/issues", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_repository :list_repo

    # Get a single issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.get 'user-name', 'repo-name', 'issue-id'
    #
    def get(user_name, repo_name, issue_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of issue_id

      normalize! params
      # _merge_mime_type(:issue, params)

      get_request("/repos/#{user}/#{repo}/issues/#{issue_id}", params)
    end
    alias :find :get

    # Create an issue
    #
    # = Inputs
    #  <tt>:title</tt> - Required string
    #  <tt>:body</tt> - Optional string
    #  <tt>:assignee</tt> - Optional string - Login for the user that this issue should be assigned to.
    #  <tt>:milestone</tt> - Optional number - Milestone to associate this issue with
    #  <tt>:labels</tt> - Optional array of strings - Labels to associate with this issue
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.issues.create
    #    "title" => "Found a bug",
    #    "body" => "I'm having a problem with this.",
    #    "assignee" => "octocat",
    #    "milestone" => 1,
    #    "labels" => [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      normalize! params
      # _merge_mime_type(:issue, params)
      filter! VALID_ISSUE_PARAM_NAMES, params
      assert_required_keys(%w[ title ], params)

      post_request("/repos/#{user}/#{repo}/issues", params)
    end

    # Edit an issue
    #
    # = Inputs
    #  <tt>:title</tt> - Optional string
    #  <tt>:body</tt> - Optional string
    #  <tt>:assignee</tt> - Optional string - Login for the user that this issue should be assigned to.
    #  <tt>:state</tt> - Optional string - State of the issue:<tt>open</tt> or <tt>closed</tt>
    #  <tt>:milestone</tt> - Optional number - Milestone to associate this issue with
    #  <tt>:labels</tt> - Optional array of strings - Labels to associate with this issue. Pass one or more Labels to replace the set of Labels on this Issue. Send an empty array ([]) to clear all Labels from the Issue.
    #
    # = Examples
    #  github = Github.new
    #  github.issues.edit 'user-name', 'repo-name', 'issue-id'
    #    "title" => "Found a bug",
    #    "body" => "I'm having a problem with this.",
    #    "assignee" => "octocat",
    #    "milestone" => 1,
    #    "labels" => [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    def edit(user_name, repo_name, issue_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of issue_id

      normalize! params
      # _merge_mime_type(:issue, params)
      filter! VALID_ISSUE_PARAM_NAMES, params

      patch_request("/repos/#{user}/#{repo}/issues/#{issue_id}", params)
    end

  end # Issues
end # Github
