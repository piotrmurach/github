# encoding: utf-8

module Github
  class Gists::Comments < API

    REQUIRED_GIST_COMMENT_INPUTS = %w[
      body
    ].freeze

    ALLOWED_GIST_COMMENT_INPUTS = %w[
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
    def list(gist_id, params={})
      normalize! params
      _validate_presence_of(gist_id)
      # _merge_mime_type(:gist_comment, params)

      response = get_request("/gists/#{gist_id}/comments", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.get 'comment-id'
    #
    def get(comment_id, params={})
      normalize! params
      _validate_presence_of(comment_id)
      # _merge_mime_type(:gist_comment, params)

      get_request("/gists/comments/#{comment_id}", params)
    end
    alias :find :get

    # Create a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.create 'gist-id'
    #
    def create(gist_id, params={})
      normalize! params
      # _merge_mime_type(:gist_comment, params)
      filter! ALLOWED_GIST_COMMENT_INPUTS, params
      assert_required_keys(REQUIRED_GIST_COMMENT_INPUTS, params)

      post_request("/gists/#{gist_id}/comments", params)
    end

    # Edit a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.edit 'comment-id'
    #
    def edit(comment_id, params={})
      normalize! params
      _validate_presence_of(comment_id)
      # _merge_mime_type(:gist_comment, params)
      filter! ALLOWED_GIST_COMMENT_INPUTS, params
      assert_required_keys(REQUIRED_GIST_COMMENT_INPUTS, params)

      patch_request("/gists/comments/#{comment_id}", params)
    end

    # Delete a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.delete 'comment-id'
    #
    def delete(comment_id, params={})
      normalize! params
      _validate_presence_of(comment_id)
      # _merge_mime_type(:gist_comment, params)

      delete_request("/gists/comments/#{comment_id}", params)
    end

  end # Gists::Comments
end # Github
