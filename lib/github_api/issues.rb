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
      'state'     => %w[ open closed ],
      'sort'      => %w[ created updated comments ],
      'direction' => %w[ desc asc ],
      'since'     => %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z}
    }

    # Access to Issues::Assignees API
    def assignees(options={}, &block)
      @assignees ||= ApiFactory.new('Issues::Assignees', current_options.merge(options), &block)
    end

    # Access to Issues::Comments API
    def comments(options={}, &block)
      @comments ||= ApiFactory.new('Issues::Comments', current_options.merge(options), &block)
    end

    # Access to Issues::Events API
    def events(options={}, &block)
      @events ||= ApiFactory.new('Issues::Events', current_options.merge(options), &block)
    end

    # Access to Issues::Comments API
    def labels(options={}, &block)
      @labels ||= ApiFactory.new('Issues::Labels', current_options.merge(options), &block)
    end

    # Access to Issues::Comments API
    def milestones(options={}, &block)
      @milestones ||= ApiFactory.new('Issues::Milestones', current_options.merge(options), &block)
    end

    # List your issues
    #
    # List all issues across all the authenticated user’s visible repositories
    # including owned repositories, member repositories,
    # and organization repositories.
    #
    # = Example
    #  github = Github.new :oauth_token => '...'
    #  github.issues.list
    #
    # List all issues across owned and member repositories for the
    # authenticated user.
    #
    # = Example
    #  github = Github.new :oauth_token => '...'
    #  github.issues.list :user
    #
    # List all issues for a given organization for the authenticated user.
    #
    # = Example
    #  github = Github.new :oauth_token => '...'
    #  github.issues.list :org => 'org-name'
    #
    # List issues for a repository
    #
    # = Example
    #  github = Github.new
    #  github.issues.list :user => 'user-name', :repo => 'repo-name'
    #
    # = Parameters
    # <tt>:filter</tt>
    #  * <tt>assigned</tt>   Issues assigned to you (default)
    #  * <tt>created</tt>    Issues created by you 
    #  * <tt>mentioned</tt>  Issues mentioning you 
    #  * <tt>subscribed</tt> Issues you've subscribed to updates for 
    #  * <tt>all</tt>        All issues the user can see 
    # <tt>:milestone</tt>
    #  * Integer Milestone number
    #  * <tt>none</tt> for Issues with no Milestone.
    #  * <tt>*</tt>    for Issues with any Milestone
    # <tt>:state</tt>  - <tt>open</tt>, <tt>closed</tt>, default: <tt>open</tt>
    # <tt>:labels</tt> - String list of comma separated Label names.
    #                   Example: bug,ui,@high
    # <tt>:assignee</tt>
    #  * String User login
    #  * <tt>none</tt> for Issues with no assigned User.
    #  * <tt>*</tt>    for Issues with any assigned User.
    # <tt>:creator</tt> String User login
    # <tt>:mentioned</tt> String User login
    # <tt>:sort</tt> - <tt>created</tt>, <tt>updated</tt>, <tt>comments</tt>,
    #                  default: <tt>created</tt>
    # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
    # <tt>:since</tt>     - Optional string of a timestamp in ISO 8601
    #                       format: YYYY-MM-DDTHH:MM:SSZ
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
    # = Examples
    #  github = Github.new
    #  github.issues.get 'user-name', 'repo-name', 'number'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :number])

      get_request("/repos/#{user}/#{repo}/issues/#{number}", arguments.params)
    end
    alias :find :get

    # Create an issue
    #
    # = Inputs
    #  <tt>:title</tt> - Required string
    #  <tt>:body</tt> - Optional string
    #  <tt>:assignee</tt> - Optional string - Login for the user that this issue should be assigned to.
    #                       Only users with push access can set the assignee for new issues.
    #                       The assignee is silently dropped otherwise.
    #  <tt>:milestone</tt> - Optional number - Milestone to associate this issue with.
    #                        Only users with push access can set the milestone for new issues.
    #                        The milestone is silently dropped otherwise.
    #  <tt>:labels</tt> - Optional array of strings - Labels to associate with this issue
    #                     Only users with push access can set labels for new issues.
    #                     Labels are silently dropped otherwise.
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
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_ISSUE_PARAM_NAMES
        assert_required %w[ title ]
      end

      post_request("/repos/#{user}/#{repo}/issues", arguments.params)
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
    #  github.issues.edit 'user-name', 'repo-name', 'number'
    #    "title" => "Found a bug",
    #    "body" => "I'm having a problem with this.",
    #    "assignee" => "octocat",
    #    "milestone" => 1,
    #    "labels" => [
    #      "Label1",
    #      "Label2"
    #    ]
    #
    def edit(*args)
      arguments(args, :required => [:user, :repo, :number]) do
        sift VALID_ISSUE_PARAM_NAMES
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}/issues/#{number}", params)
    end

  end # Issues
end # Github
