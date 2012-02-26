# encoding: utf-8

module Github
  class Issues
    module Comments

      VALID_ISSUE_COMMENT_PARAM_NAME = %w[
        body
        resource
        mime_type
      ].freeze

      # List comments on an issue
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.comments 'user-name', 'repo-name', 'issue-id'
      #  @github.issues.comments 'user-name', 'repo-name', 'issue-id' { |com| ... }
      #
      def comments(user_name, repo_name, issue_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of issue_id

        _normalize_params_keys(params)
        # _merge_mime_type(:issue_comment, params)

        response = get("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :issue_comments :comments
      alias :list_comments :comments
      alias :list_issue_comments :comments

      # Get a single comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.comment 'user-name', 'repo-name', 'comment-id'
      #
      def comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        # _merge_mime_type(:issue_comment, params)

        get("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
      end
      alias :issue_comment :comment
      alias :get_comment :comment

      # Create a comment
      #
      # = Inputs
      #  <tt>:body</tt> Required string
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.create_comment 'user-name', 'repo-name', 'issue-id',
      #     "body" => 'a new comment'
      #
      def create_comment(user_name, repo_name, issue_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of issue_id

        _normalize_params_keys(params)
        # _merge_mime_type(:issue_comment, params)
        _filter_params_keys(VALID_ISSUE_COMMENT_PARAM_NAME, params)
        raise ArgumentError, "Required params are: :body" unless _validate_inputs(%w[ body ], params)

        post("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
      end
      alias :create_issue_comment :create_comment

      # Edit a comment
      #
      # = Inputs
      #  <tt>:body</tt> Required string
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.edit_comment 'user-name', 'repo-name', 'comment-id',
      #     "body" => 'a new comment'
      #
      def edit_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        # _merge_mime_type(:issue_comment, params)
        _filter_params_keys(VALID_ISSUE_COMMENT_PARAM_NAME, params)
        raise ArgumentError, "Required params are: :body" unless _validate_inputs(%w[ body ], params)

        patch("/repos/#{user}/#{repo}/issues/comments/#{comment_id}")
      end
      alias :edit_issue_comment :edit_comment

      # Delete a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.delete_comment 'user-name', 'repo-name', 'comment-id'
      #
      def delete_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        # _merge_mime_type(:issue_comment, params)

        delete("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
      end
      alias :delete_issue_comment :delete_comment

    end # Comments
  end # Issues
end # Github
