# encoding: utf-8

module Github
  class Client::Issues::Comments < API

    VALID_ISSUE_COMMENT_PARAM_NAME = %w[
      body
      resource
      mime_type
    ].freeze

    # List comments on an issue
    #
    # @example
    #  github = Github.new
    #  github.issues.comments.all 'owner-name', 'repo-name', number: 'id'
    #  github.issues.comments.all 'owner-name', 'repo-name', number: 'id' {|com| .. }
    # @example
    #  github.issues.comments.all owner: 'username', repo: 'repo-name', number: 'id'
    #
    # List comments in a repository
    #
    # @param [Hash] params
    # @option params [String] :sort
    #   Optional string, created or updated
    # @option params [String] :direction
    #   Optional string, asc or desc. Ignored with sort parameter.
    # @option params [String] :since
    #   Optional string of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ
    #
    # @example
    #   github = Github.new
    #   github.issues.comments.all 'user-name', 'repo-name'
    #   github.issues.comments.all 'user-name', 'repo-name' {|com| .. }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params

      response = if (number = params.delete('number'))
        get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{number}/comments", params)
      else
        get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/comments", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment
    #
    # @example
    #  github = Github.new
    #  github.issues.comments.find 'user-name', 'repo-name', 'id'
    #
    # @example
    #  github.issues.comments.find owner: 'user-name', repo: 'repo-name', id: 'id'
    #
    def get(*args)
      arguments(args, required: [:user, :repo, :id])
      params = arguments.params

      get_request("/repos/#{arguments.user}/#{arguments.repo}/issues/comments/#{arguments.id}", params)
    end
    alias :find :get

    # Create a comment
    #
    # @param [Hash] params
    # @option [String] :body
    #   Required string
    #
    # @example
    #  github = Github.new
    #  github.issues.comments.create 'user-name', 'repo-name', 'number',
    #     body: 'a new comment'
    #
    # @example
    #   github.issues.comments.create
    #     user: 'owner-name',
    #     repo: 'repo-name',
    #     number: 'issue-number',
    #     body: 'a new comment body'
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :number]) do
        permit VALID_ISSUE_COMMENT_PARAM_NAME
        assert_required %w[ body ]
      end
      params = arguments.params

      post_request("/repos/#{arguments.user}/#{arguments.repo}/issues/#{arguments.number}/comments", params)
    end

    # Edit a comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required string
    #
    # @example
    #  github = Github.new
    #  github.issues.comments.edit 'owner-name', 'repo-name', 'id',
    #     body: 'a new comment'
    #
    # @example
    #   github.issues.comments.edit
    #     user: 'owner-name',
    #     repo: 'repo-name',
    #     id: 'comment-id',
    #     body: 'a new comment body'
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:user, :repo, :id]) do
        permit VALID_ISSUE_COMMENT_PARAM_NAME
        assert_required %w[ body ]
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/issues/comments/#{arguments.id}", arguments.params)
    end

    # Delete a comment
    #
    # = Examples
    #  github = Github.new
    #  github.issues.comments.delete 'owner-name', 'repo-name', 'comment-id'
    #
    # @example
    #   github.issues.comments.delete
    #     user: 'owner-name',
    #     repo: 'repo-name',
    #     id: 'comment-id',
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :id])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/issues/comments/#{arguments.id}", arguments.params)
    end
  end # Issues::Comments
end # Github
