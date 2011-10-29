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
      #  @github.issues.issue_comments 'user-name', 'repo-name', 'issue-id'
      #
      def issue_comments(user_name, repo_name, issue_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of issue_id

        _normalize_params_keys(params)
        _merge_mime_type(:issue_comment, params)

        get("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
      end

      # Get a single comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.issue_comment 'user-name', 'repo-name', 'comment-id'
      #
      def issue_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        _merge_mime_type(:issue_comment, params)

        get("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
      end

      # Create a comment
      #
      # = Inputs
      #  <tt>:body</tt> Required string
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.create_issue_comment 'user-name', 'repo-name', 'issue-id',
      #     "body" => 'a new comment'
      #
      def create_issue_comment(user_name, repo_name, issue_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of issue_id

        _normalize_params_keys(params)
        _merge_mime_type(:issue_comment, params)
        _filter_params_keys(VALID_ISSUE_COMMENT_PARAM_NAME, params)

        post("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
      end

      # Edit a comment
      #
      # = Inputs
      #  <tt>:body</tt> Required string
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.edit_issue_comment 'user-name', 'repo-name', 'comment-id',
      #     "body" => 'a new comment'
      #
      def edit_issue_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        _merge_mime_type(:issue_comment, params)
        _filter_params_keys(VALID_ISSUE_COMMENT_PARAM_NAME, params)

        patch("/repos/#{user}/#{repo}/issues/comments/#{comment_id}")
      end

      # Delete a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.delete_issue_comment 'user-name', 'repo-name', 'comment-id'
      #
      def delete_issue_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        _merge_mime_type(:issue_comment, params)

        delete("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
      end

    end # Comments
  end # Issues
end # Github
