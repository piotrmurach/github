# encoding: utf-8

module Github
  class Repos::Commits < API

      REQUIRED_COMMENT_PARAMS = %w[
        body
        commit_id
        line
        path
        position
      ].freeze

      # Compares two commits
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.compare
      #    'user-name',
      #    'repo-name',
      #    'v0.4.8',
      #    'master'
      #
      def compare(user_name, repo_name, base, head, params={})
        _validate_presence_of base, head
        normalize! params

        get_request("/repos/#{user_name}/#{repo_name}/compare/#{base}...#{head}", params)
      end

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
      #  github = Github.new
      #  github.repos.commits.create_comment 'user-name', 'repo-name', 'sha-key', 
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

        normalize! params
        filter! REQUIRED_COMMENT_PARAMS, params

        assert_required_keys(REQUIRED_COMMENT_PARAMS, params)

        post_request("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
      end

      # Deletes a commit comment
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.delete_comment 'user-name', 'repo-name', 'comment-id'
      #
      def delete_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id
        normalize! params

        delete_request("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
      end

      # List commits on a repository
      #
      # = Parameters
      # * <tt>:sha</tt>     Optional string. Sha or branch to start listing commits from.
      # * <tt>:path</tt>    Optional string. Only commits containing this file path will be returned.
      # * <tt>:author</tt>  GitHub login, name, or email by which to filter by commit author.
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.list 'user-name', 'repo-name', :sha => '...'
      #  github.repos.commits.list 'user-name', 'repo-name', :sha => '...' { |commit| ... }
      #
      def list(user_name, repo_name, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        normalize! params
        filter! %w[sha path author], params

        response = get_request("/repos/#{user}/#{repo}/commits", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :all :list

      # List commit comments for a repository
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.repo_comments 'user-name', 'repo-name'
      #  github.repos.commits.repo_comments 'user-name', 'repo-name' { |com| ... }
      #
      def repo_comments(user_name, repo_name, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        normalize! params

        response = get_request("/repos/#{user}/#{repo}/comments", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_repo_comments :repo_comments
      alias :list_repository_comments :repo_comments

      # List comments for a single commit
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.commit_comments 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed695e2e4193db5e'
      #
      def commit_comments(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha
        normalize! params

        response = get_request("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_commit_comments :commit_comments

      # Gets a single commit
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.commits.get 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed6')
      #
      def get(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha
        normalize! params

        get_request("/repos/#{user}/#{repo}/commits/#{sha}", params)
      end
      alias :find :get

      # Gets a single commit comment
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.commit_comment 'user-name', 'repo-name', 'comment-id'
      #
      def commit_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id
        normalize! params

        get_request("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
      end
      alias :get_commit_comment :commit_comment

      # Update a commit comment
      #
      # = Inputs
      # * <tt>:body</tt> - Required string.
      #
      # = Examples
      #  github = Github.new
      #  github.repos.commits.update_comment 'user-name', 'repo-name',
      #    'comment-id', "body" => "Nice change"
      #
      def update_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        normalize! params
        assert_required_keys(%w[ body ], params)

        patch_request("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
      end

  end # Repos::Commits
end # Github
