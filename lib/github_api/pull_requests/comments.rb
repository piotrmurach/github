# encoding: utf-8

module Github
  class PullRequests
    module Comments

      VALID_REQUEST_COM_PARAM_NAMES = %w[
        body
        commit_id
        path
        position
        in_reply_to
      ].freeze

      # List comments on a pull request
      #
      # = Examples
      #  @github = Github.new
      #  @github.pull_requests.request_comments 'user-name', 'repo-name', 'request-id'
      #
      def request_comments(user_name, repo_name, request_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of request_id
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/pulls/#{request_id}/comments", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Get a single comment for pull requests
      # = Examples
      #  @github = Github.new
      #  @github.pull_requests.request_comment 'user-name', 'repo-name', 'comment-id'
      #
      def request_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", params)
      end

      # Create a pull request comment
      #
      # = Inputs
      # * <tt>:body</tt> - Required string
      # * <tt>:commit_id</tt> - Required string - sha of the commit to comment on.
      # * <tt>:path</tt> - Required string - Relative path of the file to comment on.
      # * <tt>:position</tt> - Required number - Line index in the diff to comment on
      #
      # = Examples
      #  @github = Github.new
      #  @github.pull_requests.create_request_comment 'user-name', 'repo-name', 'request-id', "body" => "Nice change",
      #   "commit_id" => "6dcb09b5b57875f334f61aebed695e2e4193db5e",
      #   "path" => "file1.txt",
      #   "position" => 4
      #
      # = Alternative Inputs
      # Instead of passing commit_id, path, and position you can reply to
      # an existing Pull Request Comment like this
      # * <tt>:body</tt> - Required string
      # * <tt>:in_reply_to</tt> - Required number - comment id to reply to.
      #
      # = Examples
      #  @github = Github.new
      #  @github.pull_requests.create_request_comment 'user-name', 'repo-name', 'request-id', "body" => "Nice change",
      #   "in_reply_to" => 4
      #
      def create_request_comment(user_name, repo_name, request_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of request_id

        _normalize_params_keys(params)
        _filter_params_keys(VALID_REQUEST_COM_PARAM_NAMES, params)
        _validate_reply_to(params)

        post("/repos/#{user}/#{repo}/pulls/#{request_id}/comments", params)
      end

      # Edit a pull request comment
      #
      # = Inputs
      # * <tt>:body</tt> - Required string
      #
      # = Examples
      #  @github = Github.new
      #  @github.pull_requests.edit_request_comment 'user-name', 'repo-name', 'comment-id', "body" => "Nice change",
      #
      def edit_request_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id

        _normalize_params_keys(params)
        _filter_params_keys(VALID_REQUEST_COM_PARAM_NAMES, params)

        patch("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", params)
      end

      # Delete a pull request comment
      #
      # = Examples
      #  @github = Github.new
      #  @github.pull_requests.delete_request_comment 'user-name', 'repo-name',
      #     'comment-id'
      #
      def delete_request_comment(user_name, repo_name, comment_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of comment_id
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", params)
      end

    private

      # To let user know that the params supplied are wrong before request is made
      def _validate_reply_to(params)
        if params['in_reply_to'] && !_validate_inputs(%w[ body in_reply_to ], params)
          raise ArgumentError, "Required params are: #{%w[ body in_reply_to].join(',')}"

        elsif !_validate_inputs(VALID_REQUEST_COM_PARAM_NAMES - %w[ in_reply_to ], params)
          raise ArgumentError, "Required params are: #{VALID_REQUEST_COM_PARAM_NAMES.join(', ')}"
        end
      end

    end # Comments
  end # PullRequests
end # Github
