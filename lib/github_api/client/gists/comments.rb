# encoding: utf-8

module Github
  class Client::Gists::Comments < API

    REQUIRED_GIST_COMMENT_OPTIONS = %w[
      body
    ].freeze

    VALID_GIST_COMMENT_OPTIONS = %w[
      body
      mime_type
      resource
    ].freeze

    # List comments on a gist
    #
    # @example
    #  github = Github.new
    #  github.gists.comments.list 'gist-id'
    #
    # @return [Hash]
    #
    # @api public
    def list(*args)
      arguments(args, required: [:gist_id])

      response = get_request("/gists/#{arguments.gist_id}/comments", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment
    #
    # @example
    #  github = Github.new
    #  github.gists.comments.get 'gist-id', 'comment-id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:gist_id, :id])

      get_request("/gists/#{arguments.gist_id}/comments/#{arguments.id}", arguments.params)
    end
    alias :find :get

    # Create a comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required. The comment text.
    #
    # @example
    #  github = Github.new
    #  github.gists.comments.create 'gist-id'
    #
    # @api public
    def create(*args)
      arguments(args, required: [:gist_id]) do
        permit VALID_GIST_COMMENT_OPTIONS
        assert_required REQUIRED_GIST_COMMENT_OPTIONS
      end

      post_request("/gists/#{arguments.gist_id}/comments", arguments.params)
    end

    # Edit a comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required. The comment text.
    #
    # @example
    #  github = Github.new
    #  github.gists.comments.edit 'gist-id', 'comment-id'
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:gist_id, :id]) do
        permit VALID_GIST_COMMENT_OPTIONS
        assert_required REQUIRED_GIST_COMMENT_OPTIONS
      end

      patch_request("/gists/#{arguments.gist_id}/comments/#{arguments.id}", arguments.params)
    end

    # Delete a comment
    #
    # @xample
    #  github = Github.new
    #  github.gists.comments.delete 'gist-id', 'comment-id'
    #
    def delete(*args)
      arguments(args, required: [:gist_id, :id])

      delete_request("/gists/#{arguments.gist_id}/comments/#{arguments.id}", arguments.params)
    end
  end # Gists::Comments
end # Github
