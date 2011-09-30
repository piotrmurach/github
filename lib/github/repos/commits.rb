module Github
  class Repos
    module Commits
      
      REQUIRED_COMMENT_PARAMS = %w[ body commit_id line path position ]

      # Creates a commit comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.create_comment(...)
      #
      def create_comment(user_name=nil, repo_name=nil, params={})
        raise ArgumentError, "Expected following inputs to the method: #{REQUIRED_COMMENT_PARAMS.join(', ')}" unless _validate_inputs(REQUIRED_COMMENT_PARAMS, inputs)

        post("/repos/#{user}/#{repo}/commits/#{sha}/comments", inputs)
      end
      
      # Deletes a commit comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.delete_comment(...)
      #
      def delete_comment(user, repo, comment_id)
        delete("/repos/#{user}/#{repo}/comments/#{comment_id}")
      end

      # List commits on a repository
      #
      # = Parameters
      #  :sha   Optional string. Sha or branch to start listing commits from.
      #  :path  Optional string. Only commits containing this file path will be returned
      # = Examples
      #  @github = Github.new
      #  @github.repos.commits('user-name', 'repo-name', { :sha => ... })
      #
      def commits(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)      
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)
        _filter_params_keys(%w[ sha path], params)

        response = get("/repos/#{user}/#{repo}/commits", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # List commit comments for a repository
      # 
      # = Examples
      #  @github = Github.new
      #  @github.repos.list_repo_comments('user-name', 'repo-name')
      #
      def list_repo_comments(user_name=nil, repo_name=nil)
        _update_user_repo_params(user_name, repo_name)      
        _validate_user_repo_params(user, repo) unless user? && repo?

        response = get("/repos/#{user}/#{repo}/comments")
        return response unless block_given?
        response.each { |el| yield el }
      end
      
      # List comments for a single commit
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.list_commit_comments('user-name', 'repo-name', '6dcb09b5b57875f334f61aebed695e2e4193db5e')
      #
      def list_commit_comments(user, repo, sha)
        get("/repos/#{user}/#{repo}/commits/#{sha}/comments")
      end
      
      # Gets a single commit
      # 
      # Examples: 
      #  @github = Github.new
      #  @github.repos.get_commit('user-name', 'repo-name', '6dcb09b5b57875f334f61aebed6')
      #
      def get_commit(user, repo, sha)
        get("/repos/#{user}/#{repo}/commits/#{sha}")
      end

      # Gets a single commit comment
      # 
      # = Examples
      #  @github = Github.new
      #  @github.repos.get_comment
      #
      def get_comment(user, repo, comment_id)
        get("/repos/#{user}/#{repo}/comments/#{comment_id}")
      end

      # Gets a single commit
      #
      def get_commit(user, repo, sha)
        get("/repos/#{user}/#{repo}/commits/#{sha}")
      end
      
      # Update a commit comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.update_comment(...)
      #
      def update_comment(user, repo, comment_id)
        raise ArgumentError, "expected following inputs to the method: 'body'" unless _validate_inputs(["body"], inputs)
        patch("/repos/#{user}/#{repo}/comments/#{comment_id}")
      end
      
    end # Commits
  end # Repos
end # Github
