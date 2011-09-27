module Github
  class Repos
    module Keys
      
      # List keys
      #
      # GET /repos/:user/:repo/keys
      #
      def list(user, repo)
        get("/repos/#{user}/#{repo}/keys")
      end

      # Get a key
      #
      # GET /repos/:user/:repo/keys/:id
      #
      def get(user, repo, key_id)
        get("/repos/#{user}/#{repo}/keys/#{key_id}")
      end

      # Create a key
      #
      # POST /repos/:user/:repo/keys
      def create(user, repo, params={})
        _normalize_params_keys(params)
        _filter_params_keys(%w[ title key ], params)

        post("/repos/#{user}/#{repo}/keys", params)
      end

      # Edit key
      #
      # PATCH /repos/:user/:repo/keys/:id
      #
      def edit(user, repo, key_id)
        _normalize_params_keys(params)
        _filter_params_keys(%w[ title key ], params)

        patch("/repos/#{user}/#{repo}/keys/#{key_id}")
      end
      
      # Delete key
      #
      # DELETE /repos/:user/:repo/keys/:id
      def delete(user, repo, key_id)
        delete("/repos/#{user}/#{repo}/keys/#{key_id}")
      end

    end # Keys
  end # Repos
end # Github
