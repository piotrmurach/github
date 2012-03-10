# encoding: utf-8

module Github
  class Repos
    # The Repository Hooks API manages the post-receive web and service hooks for a repository.
    module Hooks

      VALID_HOOK_PARAM_NAMES = %w[
        name
        config
        active
        events
        add_events
        remove_events
      ].freeze # :nodoc:

      # Active hooks can be configured to trigger for one or more events. The default event is push.
      # The available events are:
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
      #  @github = Github.new
      #  @github.repos.hooks 'user-name', 'repo-name'
      #  @github.repos.hooks 'user-name', 'repo-name' { |hook| ... }
      #
      def hooks(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/hooks", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :repo_hooks :hooks
      alias :repository_hooks :hooks

      # Get a single hook
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.hook 'user-name', 'repo-name'
      #
      def hook(user_name, repo_name, hook_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of hook_id
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/hooks/#{hook_id}", params)
      end
      alias :get_hook :hook
      alias :repo_hook :hook
      alias :repository_hook :hook
      alias :get_repo_hook :hook

      # Create a hook
      #
      # = Inputs
      # * <tt>:name</tt> - Required string - the name of the service that is being called.
      # * <tt>:config</tt> - Required hash - A Hash containing key/value pairs to provide settings for this hook.
      # * <tt>:events</tt> - Optional array - Determines what events the hook is triggered for. Default: ["push"]
      # * <tt>:active</tt> - Optional boolean - Determines whether the hook is actually triggered on pushes.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.create_hook 'user-name', 'repo-name',
      #    "name" =>  "web",
      #    "active" => true,
      #    "config" => {
      #      "url" => "http://something.com/webhook"
      #      }
      #    }
      #
      def create_hook(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys(params)
        _filter_params_keys(VALID_HOOK_PARAM_NAMES, params, :recursive => false)
        _validate_inputs(REQUIRED_PARAMS, params)

        post("/repos/#{user}/#{repo}/hooks", params)
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
      #  @github = Github.new
      #  @github.repos.edit_hook 'user-name', 'repo-name',
      #    "name" => "campfire",
      #    "active" =>  true,
      #    "config" =>  {
      #      "subdomain" => "github",
      #      "room" =>  "Commits",
      #      "token" => "abc123"
      #    }
      #
      def edit_hook(user_name, repo_name, hook_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of hook_id

        _normalize_params_keys(params)
        _filter_params_keys(VALID_HOOK_PARAM_NAMES, params, :recursive => false)
        _validate_inputs(REQUIRED_PARAMS, params)

        patch("/repos/#{user}/#{repo}/hooks/#{hook_id}", params)
      end

      # Test a hook
      #
      # This will trigger the hook with the latest push to the current repository.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.test_hook 'user-name', 'repo-name', 'hook-id'
      #
      def test_hook(user_name, repo_name, hook_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of hook_id
        _normalize_params_keys(params)

        post("/repos/#{user}/#{repo}/hooks/#{hook_id}/test", params)
      end

      # Delete a hook
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.delete_hook 'user-name', 'repo-name', 'hook-id'
      #
      def delete_hook(user_name, repo_name, hook_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of hook_id
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/hooks/#{hook_id}", params)
      end

    end # Hooks
  end # Repos
end # Github
