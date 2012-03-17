# encoding: utf-8

module Github
  class Issues::Milestones < API

    VALID_MILESTONE_OPTIONS = {
     'state' => %w[ open closed ],
     'sort'  => %w[ due_date completeness ],
     'direction' => %w[ desc asc ]
    }.freeze # :nodoc:

    VALID_MILESTONE_INPUTS = %w[
      title
      state
      description
      due_on
    ].freeze # :nodoc:

    # Creates new Issues::Milestones API
    def initialize(options = {})
      super(options)
    end

    # List milestones for a repository
    #
    # = Parameters
    # <tt>:state</tt> - <tt>open</tt>, <tt>closed</tt>, default: <tt>open</tt>
    # <tt>:sort</tt> - <tt>due_date</tt>, <tt>completeness</tt>, default: <tt>due_date</tt>
    # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.issues.milestones.list
    #
    #  or
    #
    #  github.issues.milestones.list :state => 'open',
    #     :sort => 'due_date',
    #     :direction => 'asc'
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _normalize_params_keys(params)
      _filter_params_keys(VALID_MILESTONE_OPTIONS.keys, params)
      _validate_params_values(VALID_MILESTONE_OPTIONS, params)

      response = get("/repos/#{user}/#{repo}/milestones", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single milestone
    #
    # = Examples
    #  github = Github.new
    #  github.issues.milestones.find 'user-name', 'repo-name', 'milestone-id'
    #
    def find(user_name, repo_name, milestone_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of milestone_id
      _normalize_params_keys(params)

      get("/repos/#{user}/#{repo}/milestones/#{milestone_id}", params)
    end

    # Create a milestone
    #
    # = Inputs
    #  <tt>:title</tt> - Required string
    #  <tt>:state</tt> - Optional string - <tt>open</tt> or <tt>closed</tt>
    #  <tt>:description</tt> - Optional string
    #  <tt>:due_on</tt> - Optional string - ISO 8601 time
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.issues.create_milestone :title => 'hello-world',
    #    :state => "open or closed",
    #    :description => "String",
    #    :due_on => "Time"
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _normalize_params_keys(params)
      _filter_params_keys(VALID_MILESTONE_INPUTS, params)
      _validate_inputs(%w[ title ], params)

      post("/repos/#{user}/#{repo}/milestones", params)
    end

    # Update a milestone
    #
    # = Inputs
    #  <tt>:title</tt> - Required string
    #  <tt>:state</tt> - Optional string - <tt>open</tt> or <tt>closed</tt>
    #  <tt>:description</tt> - Optional string
    #  <tt>:due_on</tt> - Optional string - ISO 8601 time
    #
    # = Examples
    #  github = Github.new
    #  github.issues.update_milestone 'user-name', 'repo-name', 'milestone-id',
    #    :title => 'hello-world',
    #    :state => "open or closed",
    #    :description => "String",
    #    :due_on => "Time"
    #
    def update(user_name, repo_name, milestone_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of milestone_id

      _normalize_params_keys(params)
      _filter_params_keys(VALID_MILESTONE_INPUTS, params)
      _validate_inputs(%w[ title ], params)

      patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}", params)
    end

    # Delete a milestone
    #
    # = Examples
    #  github = Github.new
    #  github.issues.milestones.delete 'user-name', 'repo-name', 'milestone-id'
    #
    def delete(user_name, repo_name, milestone_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of milestone_id
      _normalize_params_keys(params)

      delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}", params)
    end

  end # Issues::Milestones
end # Github
