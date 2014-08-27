# encoding: utf-8

module Github
  class Client::Issues::Milestones < API

    VALID_MILESTONE_OPTIONS = {
     'state' => %w[ open closed all ],
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
    # @param [Hash] params
    # @option params [String] :state
    #   The state of the milestone. Either open, closed, or all. Default: open
    # @option params [String] :sort
    #   What to sort results by. Either due_date or completeness.
    #   Default: due_date
    # @option params [String] :direction
    #   The directoin of the sort. Either asc or desc. Default: desc
    #
    # @example
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.milestones.list
    #
    # @example
    #  github.issues.milestones.list state: 'open', sort: 'due_date',
    #    direction: 'asc'
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_MILESTONE_OPTIONS.keys
        assert_values VALID_MILESTONE_OPTIONS
      end

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/milestones", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single milestone
    #
    # @example
    #   github = Github.new
    #   github.issues.milestones.get 'user-name', 'repo-name', 'milestone-number'
    #
    # @example
    #   github.issues.milestones.get
    #     user: 'user-name',
    #     repo: 'repo-name',
    #     number: 'milestone-number'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :number])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/milestones/#{arguments.number}", arguments.params)
    end
    alias :find :get

    # Create a milestone
    #
    # @param [Hash] params
    # @option params [String] :title
    #   Required string. The title of the milestone
    # @option params [String] :state
    #   The state of the milestone. Either open or closed. Default: open.
    # @option params [String] :description
    #   A description of the milestone
    # @option params [String] :due_on
    #   The milestone due date. This is a timestamp in ISO 8601 format:
    #   YYYY-MM-DDTHH:MM:SSZ.
    #
    # @example
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.milestones.create title: 'hello-world',
    #    state: "open or closed",
    #    description: "String",
    #    due_on: "Time"
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_MILESTONE_INPUTS
        assert_required %w[ title ]
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/milestones", arguments.params)
    end

    # Update a milestone
    #
    # @param [Hash] params
    # @option params [String] :title
    #   Required string. The title of the milestone
    # @option params [String] :state
    #   The state of the milestone. Either open or closed. Default: open.
    # @option params [String] :description
    #   A description of the milestone
    # @option params [String] :due_on
    #   The milestone due date. This is a timestamp in ISO 8601 format:
    #   YYYY-MM-DDTHH:MM:SSZ.
    #
    # @example
    #   github = Github.new
    #   github.issues.milestones.update 'user-name', 'repo-name', 'number',
    #     :title => 'hello-world',
    #     :state => "open or closed",
    #     :description => "String",
    #     :due_on => "Time"
    #
    # @api public
    def update(*args)
      arguments(args, required: [:user, :repo, :number]) do
        permit VALID_MILESTONE_INPUTS
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/milestones/#{arguments.number}", arguments.params)
    end

    # Delete a milestone
    #
    # @example
    #   github = Github.new
    #   github.issues.milestones.delete 'user-name', 'repo-name', 'number'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :number])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/milestones/#{arguments.number}", arguments.params)
    end
  end # Issues::Milestones
end # Github
