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

    # List milestones for a repository
    #
    # = Parameters
    # <tt>:state</tt> - <tt>open</tt>, <tt>closed</tt>, default: <tt>open</tt>
    # <tt>:sort</tt> - <tt>due_date</tt>, <tt>completeness</tt>, default: <tt>due_date</tt>
    # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
    #
    # = Examples
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.milestones.list
    #
    #  or
    #
    #  github.issues.milestones.list state: 'open', sort: 'due_date',
    #    direction: 'asc'
    #
    def list(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_MILESTONE_OPTIONS.keys
        assert_values VALID_MILESTONE_OPTIONS
      end
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/milestones", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single milestone
    #
    # = Examples
    #  github = Github.new
    #  github.issues.milestones.get 'user-name', 'repo-name', 'milestone-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :milestone_id])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/milestones/#{milestone_id}", params)
    end
    alias :find :get

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
    #  github.issues.milestones.create :title => 'hello-world',
    #    :state => "open or closed",
    #    :description => "String",
    #    :due_on => "Time"
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_MILESTONE_INPUTS
        assert_required %w[ title ]
      end

      post_request("/repos/#{user}/#{repo}/milestones", arguments.params)
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
    #  github.issues.milestones.update 'user-name', 'repo-name', 'milestone-id',
    #    :title => 'hello-world',
    #    :state => "open or closed",
    #    :description => "String",
    #    :due_on => "Time"
    #
    def update(*args)
      arguments(args, :required => [:user, :repo, :milestone_id]) do
        sift VALID_MILESTONE_INPUTS
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}/milestones/#{milestone_id}", params)
    end

    # Delete a milestone
    #
    # = Examples
    #  github = Github.new
    #  github.issues.milestones.delete 'user-name', 'repo-name', 'milestone-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :milestone_id])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/milestones/#{milestone_id}", params)
    end

  end # Issues::Milestones
end # Github
