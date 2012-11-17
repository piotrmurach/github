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
    def list(gist_id, params={})
      normalize! params
      assert_presence_of gist_id
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
    #  github.gists.comments.get 'gist-id', 'comment-id'
    #
    def get(gist_id, comment_id, params={})
      normalize! params
      assert_presence_of comment_id
      # _merge_mime_type(:gist_comment, params)

      get_request("/gists/#{gist_id}/comments/#{comment_id}", params)
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
      filter! VALID_GIST_COMMENT_OPTIONS, params
      assert_required_keys(REQUIRED_GIST_COMMENT_OPTIONS, params)

      post_request("/gists/#{gist_id}/comments", params)
    end

    # Edit a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.edit 'gist-id', 'comment-id'
    #
    def edit(gist_id, comment_id, params={})
      normalize! params
      assert_presence_of comment_id
      # _merge_mime_type(:gist_comment, params)
      filter! VALID_GIST_COMMENT_OPTIONS, params
      assert_required_keys(REQUIRED_GIST_COMMENT_OPTIONS, params)

      patch_request("/gists/#{gist_id}/comments/#{comment_id}", params)
    end

    # Delete a comment
    #
    # = Examples
    #  github = Github.new
    #  github.gists.comments.delete 'gist-id', 'comment-id'
    #
    def delete(gist_id, comment_id, params={})
      normalize! params
      assert_presence_of comment_id
      # _merge_mime_type(:gist_comment, params)

      delete_request("/gists/#{gist_id}/comments/#{comment_id}", params)
    end

  end # Gists::Comments
end # Github
