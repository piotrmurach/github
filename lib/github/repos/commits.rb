module Github
  module Repos
    module Commits
      
      REQUIRED_COMMENT_PARAMS = ["body", "commit_id", "line", "path", "position"]

      # Creates a commit comment
      #
      # POST /repos/:user/:repo/commits/:sha/comments
      #
      # Examples:
      #
      def create_comment(user, repo, sha, inputs={})
        raise ArgumentError, "expected following inputs to the method: #{REQUIRED_COMMENT_PARAMS.join(', ')}" unless _validate_inputs(REQUIRED_COMMENT_PARAMS, inputs)

        post("/repos/#{user}/#{repo}/commits/#{sha}/comments", inputs)
      end
      
      # Deletes a commit comment
      #
      # DELETE /repos/:user/:repo/comments/:id
      #
      # Examples: 
      #
      def delete_comment(user, repo, comment_id)
        delete("/repos/#{user}/#{repo}/comments/#{comment_id}")
      end

      # List commits on a repository
      #
      # GET /repos/:user/:repo/commits
      #
      # Examples:
      #   client = Client.new
      #   client.list('user', 'repo-name')
      #
      def list(user, repo, params={})
        _normalize_params_keys(params)
        _filter_params_keys(["sha", "path"], params)

        get("/repos/#{user}/#{repo}/commits", valid_options)
      end

      # List commit comments for a repository
      # 
      # GET /repos/:user/:repo/comments
      #
      def list_repo_comments
        get("/repos/#{user}/#{repo}/comments")
      end
      
      # List comments for a single commit
      #
      # GET /repos/:user/:repo/commits/:sha/comments
      #
      def list_commit_comments(user, repo, sha)
        get("/repos/#{user}/#{repo}/commits/#{sha}/comments")
      end
      
      # Gets a single commit
      # 
      # GET /repos/:user/:repo/commits/:sha
      # 
      # Examples: 
      #
      def get(user, repo, sha)
        get("/repos/#{user}/#{repo}/commits/#{sha}")
      end

      # Gets a single commit comment
      # 
      # GET /repos/:user/:repo/comments/:id
      #
      def get_comment(user, repo, comment_id)
        get("/repos/#{user}/#{repo}/comments/#{comment_id}")
      end

      # Gets a single commit
      #
      # GET /repos/:user/:repo/commits/:sha
      #
      def get_commit(user, repo, sha)
        get("/repos/#{user}/#{repo}/commits/#{sha}")
      end
      
      # Update a commit comment
      #
      # PATCH /repos/:user/:repo/comments/:id
      #
      def update_comment(user, repo, comment_id)
        raise ArgumentError, "expected following inputs to the method: 'body'" unless _validate_inputs(["body"], inputs)
        patch("/repos/#{user}/#{repo}/comments/#{comment_id}")
      end
      
    end # Commits
  end # Repos
end # Github
