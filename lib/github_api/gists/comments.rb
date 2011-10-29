# encoding: utf-8

module Github
  class Gists
    module Comments

      REQUIRED_GIST_COMMENT_INPUTS = %w[ 
        body
        mime_type
        resource
      ].freeze

      # List comments on a gist
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.gist_comments 'gist-id'
      #
      def gist_comments(gist_id, params={})
        _normalize_params_keys(params)
        _merge_mime_type(:gist_comment, params)

        get("/gists/#{gist_id}/comments", params)
      end

      # Get a single comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.gist_comment 'comment-id'
      #
      def gist_comment(comment_id, params={})
        _normalize_params_keys(params)
        _merge_mime_type(:gist_comment, params)

        get("/gists/comments/#{comment_id}", params)
      end

      # Create a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.create_gist_comment 'gist-id'
      #
      def create_gist_comment(gist_id, params={})
        _normalize_params_keys(params)
        _merge_mime_type(:gist_comment, params)
        _filter_params_keys(REQUIRED_GIST_COMMENT_INPUTS, params)

        raise ArgumentError, "Required inputs are: :body" unless _validate_inputs(REQUIRED_GIST_COMMENT_INPUTS, params)

        post("/gists/#{gist_id}/comments", params)
      end

      # Edit a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.edit_gist_comment 'comment-id'
      #
      def edit_gist_comment(comment_id, params={})
        _normalize_params_keys(params)
        _merge_mime_type(:gist_comment, params)
        _filter_params_keys(REQUIRED_GIST_COMMENT_INPUTS, params)

        raise ArgumentError, "Required inputs are: :body" unless _validate_inputs(REQUIRED_GIST_COMMENT_INPUTS, params)

        patch("/gists/comments/#{comment_id}", params)
      end

      # Delete a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.delete_gist_comment 'comment-id'
      #
      def delete_gist_comment(comment_id, params={})
        _normalize_params_keys(params)
        _merge_mime_type(:gist_comment, params)

        delete("/gists/comments/#{comment_id}", params)
      end

    end # Comments
  end # Gists
end # Github
