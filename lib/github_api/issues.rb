# encoding: utf-8

module Github
  class Issues < API
    extend AutoloadHelper

    autoload_all 'github_api/issues',
      :Comments   => 'comments',
      :Events     => 'events',
      :Labels     => 'labels',
      :Milestones => 'milestones'

    include Github::Issues::Comments
    include Github::Issues::Events
    include Github::Issues::Labels
    include Github::Issues::Milestones

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
      'since'     => %r{\d{4}-\d{2}-\d{5}:\d{2}:\d{3}}
    }

    # Creates new Issues API
    def initialize(options = {})
      super(options)
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
    #  @github = Github.new :oauth_token => '...'
    #  @github.issues.issues :since => '2011-04-12312:12:121',
    #    :filter => 'created',
    #    :state  => 'open',
    #    :labels => "bug,ui,bla",
    #    :sort   => 'comments',
    #    :direction => 'asc'
    #
    def issues(params={})
      _normalize_params_keys(params)
      _filter_params_keys(VALID_ISSUE_PARAM_NAMES, params)
      _merge_mime_type(:issue, params)
      _validate_params_values(VALID_ISSUE_PARAM_VALUES, params)

      response = get("/issues", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_issues :issues

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
    #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  @github.issues.repo_issues :milestone => 1,
    #    :state  => 'open',
    #    :assignee => '*',
    #    :mentioned => 'octocat',
    #    :labels => "bug,ui,bla",
    #    :sort   => 'comments',
    #    :direction => 'asc'
    #
    def repo_issues(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _normalize_params_keys(params)
      _filter_params_keys(VALID_ISSUE_PARAM_NAMES, params)
      _merge_mime_type(:issue, params)
      _validate_params_values(VALID_ISSUE_PARAM_VALUES, params)

      response = get("/repos/#{user}/#{repo}/issues", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :repository_issues :repo_issues
    alias :list_repo_issues :repo_issues
    alias :list_repository_issues :repo_issues

    # Get a single issue
    #
    # = Examples
    #  @github = Github.new
    #  @github.issues.get_issue 'user-name', 'repo-name', 'issue-id'
    #
    def issue(user_name, repo_name, issue_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of issue_id

      _normalize_params_keys(params)
      _merge_mime_type(:issue, params)

      get("/repos/#{user}/#{repo}/issues/#{issue_id}", params)
    end
    alias :get_issue :issue

    # Create an issue
    #
    # = Inputs
    #  <tt>:title</tt> - Required string
    #  <tt>:body</tt> - Optional string
    #  <tt>:assignee</tt> - Optional string - Login for the user that this issue should be assigned to.
    #  <tt>:milestone</tt> - Optional number - Milestone to associate this issue with
    #  <tt>:labels</tt> - Optional array of strings - Labels to associate with this issue
    # = Examples
    #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  @github.issues.create_issue
    #    "title" => "Found a bug",
    #    "body" => "I'm having a problem with this.",
    #    "assignee" => "octocat",
    #    "milestone" => 1,
    #    "labels" => [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    def create_issue(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _normalize_params_keys(params)
      _merge_mime_type(:issue, params)
      _filter_params_keys(VALID_ISSUE_PARAM_NAMES, params)

      raise ArgumentError, "Required params are: :title" unless _validate_inputs(%w[ title ], params)

      post("/repos/#{user}/#{repo}/issues", params)
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
    #  @github = Github.new
    #  @github.issues.create_issue 'user-name', 'repo-name', 'issue-id'
    #    "title" => "Found a bug",
    #    "body" => "I'm having a problem with this.",
    #    "assignee" => "octocat",
    #    "milestone" => 1,
    #    "labels" => [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    def edit_issue(user_name, repo_name, issue_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of issue_id

      _normalize_params_keys(params)
      _merge_mime_type(:issue, params)
      _filter_params_keys(VALID_MILESTONE_INPUTS, params)

      patch("/repos/#{user}/#{repo}/issues/#{issue_id}", params)
    end

  end # Issues
end # Github
