module Github
  class Repos
    module Hooks

      REQUIRED_PARAMS = %w[ name config ]

      # List repository hooks
      # 
      # GET /repos/:user/:repo/hooks
      #
      def list(user, repo)
        get("/repos/#{user}/#{repo}/hooks")
      end

      # Get a single hook 
      #
      # GET /repos/:user/:repo/hooks/:id
      #
      def get(user, repo, hook_id)
        get("/repos/#{user}/#{repo}/hooks/#{hook_id}")
      end

      # Create a hook
      #
      # POST /repos/:user/:repo/hooks
      #
      def create(user, repo, params)
        _normalize_params_keys(params)
        _filter_params_keys(%w[ name config active ], params)
        raise ArgumentError, "Required parameters are: #{REQUIRED_PARAMS.join(', ')}" unless _validate_inputs(REQUIRED_PARAMS, params)

        post("/repos/#{user}/#{repo}/hooks", params)
      end

      # Edit a hook
      #
      # PATCH /repos/:user/:repo/hooks/:id
      # 
      def edit(user, repo, hook_id, params)
        _normalize_params_keys(params)
        _filter_params_keys(%w[ name config active ], params)
        raise ArgumentError, "Required parameters are: #{REQUIRED_PARAMS.join(', ')}" unless _validate_inputs(REQUIRED_PARAMS, params)

        patch("/repos/#{user}/#{repo}/hooks/#{hook_id}")
      end

      # Test a hook
      #
      # POST /repos/:user/:repo/hooks/:id/test
      #
      def test(user, repo, hook_id)
        post("/repos/#{user}/#{repo}/hooks/#{hook_id}/test")
      end

      # Delete a hook
      #
      # DELETE /repos/:user/:repo/hooks/:id
      #
      def delete(user, repo, hook_id)
        delete("/repos/#{user}/#{repo}/hooks/#{hook_id}")
      end

    end # Hooks
  end # Repos
end # Github
