# encoding: utf-8

module Github
  class Gists
    module Comments

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
      #  @github = Github.new
      #  @github.gists.comments 'gist-id'
      #
      def comments(gist_id, params={})
        _normalize_params_keys(params)
        _validate_presence_of(gist_id)
        _merge_mime_type(:gist_comment, params)

        response = get("/gists/#{gist_id}/comments", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_comments :comments
      alias :gist_comments :comments

      # Get a single comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.comment 'comment-id'
      #
      def comment(comment_id, params={})
        _normalize_params_keys(params)
        _validate_presence_of(comment_id)
        _merge_mime_type(:gist_comment, params)

        get("/gists/comments/#{comment_id}", params)
      end
      alias :gist_comment :comment
      alias :get_comment  :comment

      # Create a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.create_comment 'gist-id'
      #
      def create_comment(gist_id, params={})
        _normalize_params_keys(params)
        _merge_mime_type(:gist_comment, params)
        _filter_params_keys(ALLOWED_GIST_COMMENT_INPUTS, params)

        unless _validate_inputs(REQUIRED_GIST_COMMENT_INPUTS, params)
          puts params
          raise ArgumentError, "Required inputs are: :body"
        end

        post("/gists/#{gist_id}/comments", params)
      end
      alias :create_gist_comment :create_comment

      # Edit a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.edit_comment 'comment-id'
      #
      def edit_comment(comment_id, params={})
        _normalize_params_keys(params)
        _validate_presence_of(comment_id)
        _merge_mime_type(:gist_comment, params)
        _filter_params_keys(ALLOWED_GIST_COMMENT_INPUTS, params)

        unless _validate_inputs(REQUIRED_GIST_COMMENT_INPUTS, params)
          raise ArgumentError, "Required inputs are: :body"
        end

        patch("/gists/comments/#{comment_id}", params)
      end
      alias :edit_gist_comment :edit_comment

      # Delete a comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.gists.delete_comment 'comment-id'
      #
      def delete_comment(comment_id, params={})
        _normalize_params_keys(params)
        _validate_presence_of(comment_id)
        _merge_mime_type(:gist_comment, params)

        delete("/gists/comments/#{comment_id}", params)
      end
      alias :delete_gist_comment :delete_comment

    end # Comments
  end # Gists
end # Github
