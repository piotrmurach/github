# encoding: utf-8

module Github

  # The Repository Hooks API manages the post-receive web and
  # service hooks for a repository.
  class Repos::Hooks < API

    VALID_HOOK_PARAM_NAMES = %w[
      name
      config
      active
      events
      add_events
      remove_events
    ].freeze # :nodoc:

    # Active hooks can be configured to trigger for one or more events.
    # The default event is push. The available events are:
    VALID_HOOK_PARAM_VALUES = {
      'events' => %w[
        push
        issues
        issue_comment
        commit_comment
        pull_request
        gollum
        watch
        download
        fork
        fork_apply
        member
        public
      ]
    }.freeze # :nodoc:

    REQUIRED_PARAMS = %w[ name config ].freeze # :nodoc:

    # List repository hooks
    #
    # = Examples
    #  github = Github.new
    #  github.repos.hooks.list 'user-name', 'repo-name'
    #  github.repos.hooks.list 'user-name', 'repo-name' { |hook| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/repos/#{user}/#{repo}/hooks", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single hook
    #
    # = Examples
    #  github = Github.new
    #  github.repos.hooks.get 'user-name', 'repo-name', 'hook-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :id])

      get_request("/repos/#{user}/#{repo}/hooks/#{id}", arguments.params)
    end
    alias :find :get

    # Create a hook
    #
    # = Inputs
    # * <tt>:name</tt> - Required string - the name of the service that is being called.
    # * <tt>:config</tt> - Required hash - A Hash containing key/value pairs to provide settings for this hook.
    # * <tt>:events</tt> - Optional array - Determines what events the hook is triggered for. Default: ["push"]
    # * <tt>:active</tt> - Optional boolean - Determines whether the hook is actually triggered on pushes.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.hooks.create 'user-name', 'repo-name',
    #    "name" =>  "web",
    #    "active" => true,
    #    "config" => {
    #      "url" => "http://something.com/webhook"
    #      }
    #    }
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_HOOK_PARAM_NAMES, :recursive => false
        assert_required REQUIRED_PARAMS
      end

      post_request("/repos/#{user}/#{repo}/hooks", arguments.params)
    end

    # Edit a hook
    #
    # = Inputs
    # * <tt>:name</tt> - Required string - the name of the service that is being called.
    # * <tt>:config</tt> - Required hash - A Hash containing key/value pairs to provide settings for this hook.
    # * <tt>:events</tt> - Optional array - Determines what events the hook is triggered for. This replaces the entire array of events. Default: ["push"].
    # * <tt>:add_events</tt> - Optional array - Determines a list of events to be added to the list of events that the Hook triggers for.
    # * <tt>:remove_events</tt> - Optional array - Determines a list of events to be removed from the list of events that the Hook triggers for.
    # * <tt>:active</tt> - Optional boolean - Determines whether the hook is actually triggered on pushes.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.hooks.edit 'user-name', 'repo-name', 'hook-id',
    #    "name" => "campfire",
    #    "active" =>  true,
    #    "config" =>  {
    #      "subdomain" => "github",
    #      "room" =>  "Commits",
    #      "token" => "abc123"
    #    }
    #
    def edit(*args)
      arguments(args, :required => [:user, :repo, :id]) do
        sift VALID_HOOK_PARAM_NAMES, :recursive => false
        assert_required REQUIRED_PARAMS
      end

      patch_request("/repos/#{user}/#{repo}/hooks/#{id}", arguments.params)
    end

    # Test a hook
    #
    # This will trigger the hook with the latest push to the current repository.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.hooks.test 'user-name', 'repo-name', 'hook-id'
    #
    def test(*args)
      arguments(args, :required => [:user, :repo, :id])
      params = arguments.params

      post_request("/repos/#{user}/#{repo}/hooks/#{id}/test", params)
    end

    # Delete a hook
    #
    # = Examples
    #  github = Github.new
    #  github.repos.hooks.delete 'user-name', 'repo-name', 'hook-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :id])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/hooks/#{id}", params)
    end

  end # Repos::Hooks
end # Github
