# encoding: utf-8

module Github
  class Issues::Comments < API

    VALID_ISSUE_COMMENT_PARAM_NAME = %w[
      body
      resource
      mime_type
    ].freeze

    # Creates new Issues::Comments API
    def initialize(options = {})
      super(options)
    end

    # List comments on an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.all 'user-name', 'repo-name', 'issue-id'
    #  github.issues.comments.all 'user-name', 'repo-name', 'issue-id' {|com| .. }
    #
    def list(user_name, repo_name, issue_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of issue_id

      _normalize_params_keys(params)
      # _merge_mime_type(:issue_comment, params)

      response = get("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.find 'user-name', 'repo-name', 'comment-id'
    #
    def find(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      _normalize_params_keys(params)
      # _merge_mime_type(:issue_comment, params)

      get("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
    end

    # Create a comment
    #
    # = Inputs
    #  <tt>:body</tt> Required string
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.create 'user-name', 'repo-name', 'issue-id',
    #     "body" => 'a new comment'
    #
    def create(user_name, repo_name, issue_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of issue_id

      _normalize_params_keys(params)
      # _merge_mime_type(:issue_comment, params)
      _filter_params_keys(VALID_ISSUE_COMMENT_PARAM_NAME, params)
      _validate_inputs(%w[ body ], params)

      post("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
    end

    # Edit a comment
    #
    # = Inputs
    #  <tt>:body</tt> Required string
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.edit 'user-name', 'repo-name', 'comment-id',
    #     "body" => 'a new comment'
    #
    def edit(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      _normalize_params_keys(params)
      # _merge_mime_type(:issue_comment, params)
      _filter_params_keys(VALID_ISSUE_COMMENT_PARAM_NAME, params)
      _validate_inputs(%w[ body ], params)

      patch("/repos/#{user}/#{repo}/issues/comments/#{comment_id}")
    end

    # Delete a comment
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.delete 'user-name', 'repo-name', 'comment-id'
    #
    def delete(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      _normalize_params_keys(params)
      # _merge_mime_type(:issue_comment, params)

      delete("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
    end

  end # Issues::Comments
end # Github
