# encoding: utf-8

module Github
  class PullRequests::Comments < API

    VALID_REQUEST_COM_PARAM_NAMES = %w[
      body
      commit_id
      path
      position
      in_reply_to
      mime_type
      resource
    ].freeze

    # List comments on a pull request
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.list 'user-name', 'repo-name', 'request-id'
    #
    def list(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_comment, params)

      response = get_request("/repos/#{user}/#{repo}/pulls/#{request_id}/comments", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment for pull requests
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.get 'user-name', 'repo-name', 'comment-id'
    #
    def get(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      normalize! params
      # _merge_mime_type(:pull_comment, params)

      get_request("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", params)
    end
    alias :find :get

    # Create a pull request comment
    #
    # = Inputs
    # * <tt>:body</tt> - Required string
    # * <tt>:commit_id</tt> - Required string - sha of the commit to comment on.
    # * <tt>:path</tt> - Required string - Relative path of the file to comment on.
    # * <tt>:position</tt> - Required number - Line index in the diff to comment on
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.create 'user-name','repo-name','request-id',
    #   "body" => "Nice change",
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
    #  github = Github.new
    #  github.pull_requests.comments.create 'user-name','repo-name','request-id',
    #    "body" => "Nice change",
    #    "in_reply_to" => 4
    #
    def create(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_comment, params)
      filter! VALID_REQUEST_COM_PARAM_NAMES, params
      # _validate_reply_to(params)

      post_request("/repos/#{user}/#{repo}/pulls/#{request_id}/comments", params)
    end

    # Edit a pull request comment
    #
    # = Inputs
    # * <tt>:body</tt> - Required string
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.edit 'user-name', 'repo-name','comment-id',
    #    "body" => "Nice change"
    #
    def edit(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      normalize! params
      # _merge_mime_type(:pull_comment, params)
      filter! VALID_REQUEST_COM_PARAM_NAMES, params

      patch_request("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", params)
    end

    # Delete a pull request comment
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.delete 'user-name', 'repo-name','comment-id'
    #
    def delete(user_name, repo_name, comment_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of comment_id

      normalize! params
      # _merge_mime_type(:pull_comment, params)

      delete_request("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", params)
    end

  private

    # To let user know that the params supplied are wrong before request is made
    def _validate_reply_to(params)
      if params['in_reply_to'] && !assert_required_keys(%w[ body in_reply_to ], params)
        raise ArgumentError, "Required params are: #{%w[ body in_reply_to].join(',')}"

      elsif !assert_required_keys(VALID_REQUEST_COM_PARAM_NAMES - %w[ in_reply_to ], params)
        raise ArgumentError, "Required params are: #{VALID_REQUEST_COM_PARAM_NAMES.join(', ')}"
      end
    end

  end # PullRequests::Comments
end # Github
