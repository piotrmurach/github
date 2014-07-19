# encoding: utf-8

module Github
  class Client::Repos::Comments < API

    REQUIRED_COMMENT_OPTIONS = %w[ body ].freeze

    VALID_COMMENT_OPTIONS = %w[
      body
      line
      path
      position
    ].freeze

    # List commit comments for a repository
    #
    # @example
    #  github = Github.new
    #  github.repos.comments.list 'user-name', 'repo-name'
    #
    # @example
    #  github.repos.comments.list 'user-name', 'repo-name' { |com| ... }
    #
    # List comments for a single commit
    #
    # @example
    #  github.repos.comments.list 'user-name', 'repo-name',
    #   sha: '6dcb09b5b57875f334f61aebed695e2e4193db5e'
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params
      user   = arguments.user
      repo   = arguments.repo

      response = if (sha = params.delete('sha'))
        get_request("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
      else
        get_request("/repos/#{user}/#{repo}/comments", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Gets a single commit comment
    #
    # @example
    #  github = Github.new
    #  github.repos.comments.get 'user-name', 'repo-name', 'id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :id])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/comments/#{arguments.id}", arguments.params)
    end
    alias :find :get

    # Creates a commit comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required. The contents of the comment.
    # @option params [String] :path
    #   Required. Relative path of the file to comment on.
    # @option params [Number] :position
    #   Required number - Line index in the diff to comment on.
    # @option params [Number] :line
    #   Required number - Line number in the file to comment on.
    #
    # @example
    #  github = Github.new
    #  github.repos.comments.create 'user-name', 'repo-name', 'sha-key',
    #    body: "Nice change",
    #    position: 4,
    #    line: 1,
    #    path: "file1.txt"
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :sha]) do
        permit VALID_COMMENT_OPTIONS
        assert_required REQUIRED_COMMENT_OPTIONS
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/commits/#{arguments.sha}/comments", arguments.params)
    end

    # Update a commit comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required. The contents of the comment.
    #
    # @example
    #   github = Github.new
    #   github.repos.comments.update 'user-name', 'repo-name', 'id',
    #     body: "Nice change"
    #
    # @api public
    def update(*args)
      arguments(args, required: [:user, :repo, :id]) do
        assert_required REQUIRED_COMMENT_OPTIONS
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/comments/#{arguments.id}", arguments.params)
    end

    # Deletes a commit comment
    #
    # @example
    #   github = Github.new
    #   github.repos.comments.delete 'user-name', 'repo-name', 'id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :id])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/comments/#{arguments.id}", arguments.params)
    end
  end # Client::Repos::Comments
end # Github
