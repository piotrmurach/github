# encoding: utf-8

module Github
  class Gists::Comments < API

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
    # = Examples
    #  github = Github.new
    #  github.gists.comments.list 'gist-id'
    #
    def list(*args)
      arguments(args, :required => [:gist_id])

      response = get_request("/gists/#{gist_id}/comments", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.get 'gist-id', 'comment-id'
    #
    def get(*args)
      arguments(args, :required => [:gist_id, :comment_id])

      get_request("/gists/#{gist_id}/comments/#{comment_id}", arguments.params)
    end
    alias :find :get

    # Create a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.create 'gist-id'
    #
    def create(*args)
      arguments(args, :required => [:gist_id]) do
        sift VALID_GIST_COMMENT_OPTIONS
        assert_required REQUIRED_GIST_COMMENT_OPTIONS
      end

      post_request("/gists/#{gist_id}/comments", arguments.params)
    end

    # Edit a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.edit 'gist-id', 'comment-id'
    #
    def edit(*args)
      arguments(args, :required => [:gist_id, :comment_id]) do
        sift VALID_GIST_COMMENT_OPTIONS
        assert_required REQUIRED_GIST_COMMENT_OPTIONS
      end

      patch_request("/gists/#{gist_id}/comments/#{comment_id}", arguments.params)
    end

    # Delete a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.delete 'gist-id', 'comment-id'
    #
    def delete(*args)
      arguments(args, :required => [:gist_id, :comment_id])

      delete_request("/gists/#{gist_id}/comments/#{comment_id}", arguments.params)
    end

  end # Gists::Comments
end # Github
