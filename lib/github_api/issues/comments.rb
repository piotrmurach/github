# encoding: utf-8

module Github
  class Issues::Comments < API

    VALID_ISSUE_COMMENT_PARAM_NAME = %w[
      body
      resource
      mime_type
    ].freeze

    # List comments on an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.all 'user-name', 'repo-name', issue_id: 'id'
    #  github.issues.comments.all 'user-name', 'repo-name', issue_id: 'id' {|com| .. }
    #
    # List comments in a repository
    #
    # = Parameters
    # * <tt>:sort</tt>      - Optional string, <tt>created</tt> or <tt>updated</tt>
    # * <tt>:direction</tt> - Optional string, <tt>asc</tt> or <tt>desc</tt>.
    #                         Ignored with sort parameter.
    # * <tt>:since</tt>     - Optional string of a timestamp in ISO 8601
    #                         format: YYYY-MM-DDTHH:MM:SSZ
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.all 'user-name', 'repo-name'
    #  github.issues.comments.all 'user-name', 'repo-name' {|com| .. }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = if (issue_id = params.delete('issue_id'))
        get_request("/repos/#{user}/#{repo}/issues/#{issue_id}/comments", params)
      else
        get_request("/repos/#{user}/#{repo}/issues/comments", params)
      end
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
    def get(*args)
      arguments(args, :required => [:user, :repo, :comment_id])
      params = arguments.params

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
    #     'body': 'a new comment'
    #
    def create(*args)
      arguments(args, :required => [:user, :repo, :issue_id]) do
        sift VALID_ISSUE_COMMENT_PARAM_NAME
        assert_required %w[ body ]
      end
      params = arguments.params

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
    #     'body': 'a new comment'
    #
    def edit(*args)
      arguments(args, :required => [:user, :repo, :comment_id]) do
        sift VALID_ISSUE_COMMENT_PARAM_NAME
        assert_required %w[ body ]
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
    end

    # Delete a comment
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.delete 'user-name', 'repo-name', 'comment-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :comment_id])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/issues/comments/#{comment_id}", params)
    end

  end # Issues::Comments
end # Github
