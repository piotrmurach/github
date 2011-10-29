# encoding: utf-8

module Github
  class Repos
    module Commits

      REQUIRED_COMMENT_PARAMS = %w[
        body
        commit_id
        line
        path
        position
      ].freeze

      # Creates a commit comment
      #
      # = Inputs
      # * <tt>:body</tt> - Required string.
      # * <tt>:comment_id</tt> - Required string - Sha of the commit to comment on.
      # * <tt>:line</tt> - Required number - Line number in the file to comment on.
      # * <tt>:path</tt> - Required string - Relative path of the file to comment on.
      # * <tt>:position</tt> - Required number - Line index in the diff to comment on.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.create_comment 'user-name', 'repo-name', 'sha-key', 
      #    "body" => "Nice change",
      #    "commit_id" => "6dcb09b5b57875f334f61aebed695e2e4193db5e",
      #    "line" => 1,
      #    "path" =>  "file1.txt",
      #    "position" =>  4
      #
      def create_comment(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha

        _normalize_params_keys(params)
        _filter_params_keys(REQUIRED_COMMENT_PARAMS, params)

        raise ArgumentError, "Expected following inputs to the method: #{REQUIRED_COMMENT_PARAMS.join(', ')}" unless _validate_inputs(REQUIRED_COMMENT_PARAMS, params)

        post("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
      end
      alias :create_commit_comment :create_comment

      # Deletes a commit comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.delete_comment 'user-name', 'repo-name', 'comment-id'
      #
      def delete_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
      end
      alias :delete_commit_comment :delete_comment

      # List commits on a repository
      #
      # = Parameters
      # * <tt>:sha</tt>   Optional string. Sha or branch to start listing commits from.
      # * <tt>:path</tt>  Optional string. Only commits containing this file path will be returned
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.commits 'user-name', 'repo-name', :sha => '...'
      #  @github.repos.commits 'user-name', 'repo-name', :sha => '...' { |commit| ... }
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
      alias :list_commits :commits
      alias :list_repo_commits :commits
      alias :list_repository_commits :commits

      # List commit comments for a repository
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.repo_comments 'user-name', 'repo-name'
      #  @github.repos.repo_comments 'user-name', 'repo-name' { |com| ... }
      #
      def repo_comments(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/comments")
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_repo_comments :repo_comments
      alias :list_repository_comments :repo_comments

      # List comments for a single commit
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.commit_comments 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed695e2e4193db5e'
      #
      def commit_comments(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_commit_comments :commit_comments

      # Gets a single commit
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.commit 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed6')
      #
      def commit(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/commits/#{sha}", params)
      end
      alias :get_commit :commit

      # Gets a single commit comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.commit_comment 'user-name', 'repo-name', 'comment-id'
      #
      def commit_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
      end
      alias :get_commit_comment :commit_comment

      # Update a commit comment
      #
      # = Inputs
      # * <tt>:body</tt> - Required string.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.update_comment 'user-name', 'repo-name', 'comment-id',
      #    "body" => "Nice change"
      #
      def update_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        raise ArgumentError, "expected following inputs to the method: 'body'" unless _validate_inputs(["body"], params)

        patch("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
      end

    end # Commits
  end # Repos
end # Github
