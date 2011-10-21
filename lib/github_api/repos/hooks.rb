# encoding: utf-8

module Github
  class Repos
    # The Repository Hooks API manages the post-receive web and service hooks for a repository.
    module Hooks

      VALID_KEY_PARAM_NAMES = %w[ name config active events ].freeze
      REQUIRED_PARAMS = %w[ name config ]

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
        _filter_params_keys(VALID_KEY_PARAM_NAMES, params)

        raise ArgumentError, "Required parameters are: name, config" unless _validate_inputs(%w[ name config], params)

        post("/repos/#{user}/#{repo}/hooks", params)
      end

      # Edit a hook
      #
      # = Inputs
      # * <tt>:name</tt> - Required string - the name of the service that is being called.
      # * <tt>:config</tt> - Required hash - A Hash containing key/value pairs to provide settings for this hook.
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
        _filter_params_keys(VALID_KEY_PARAM_NAMES, params)

        raise ArgumentError, "Required parameters are: name, config" unless _validate_inputs(%w[ name config], params)

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
