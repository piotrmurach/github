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

      normalize! params
      # _merge_mime_type(:issue_comment, params)

      response = get_request("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
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
    def get(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      normalize! params
      # _merge_mime_type(:issue_comment, params)

      get_request("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
    end
    alias :find :get

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

      normalize! params
      # _merge_mime_type(:issue_comment, params)
      filter! VALID_ISSUE_COMMENT_PARAM_NAME, params
      assert_required_keys(%w[ body ], params)

      post_request("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
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

      normalize! params
      # _merge_mime_type(:issue_comment, params)
      filter! VALID_ISSUE_COMMENT_PARAM_NAME, params
      assert_required_keys(%w[ body ], params)

      patch_request("/repos/#{user}/#{repo}/issues/comments/#{comment_id}")
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

      normalize! params
      # _merge_mime_type(:issue_comment, params)

      delete_request("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
    end

  end # Issues::Comments
end # Github
