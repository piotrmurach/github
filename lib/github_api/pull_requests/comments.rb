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
    #  github.pull_requests.comments.list 'user-name', 'repo-name', request_id: 'id'
    #
    # List comments in a repository
    #
    # By default, Review Comments are ordered by ascending ID.
    #
    # = Parameters
    #
    # * <tt>:sort</tt>      - Optional string, <tt>created</tt> or <tt>updated</tt>
    # * <tt>:direction</tt> - Optional string, <tt>asc</tt> or <tt>desc</tt>.
    #                         Ignored with sort parameter.
    # * <tt>:since</tt>     - Optional string of a timestamp in ISO 8601
    #                         format: YYYY-MM-DDTHH:MM:SSZ
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.list 'user-name', 'repo-name'
    #  github.pull_requests.comments.list 'user-name', 'repo-name' { |comm| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = if (request_id = params.delete('request_id'))
        get_request("/repos/#{user}/#{repo}/pulls/#{request_id}/comments", params)
      else
        get_request("/repos/#{user}/#{repo}/pulls/comments", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single comment for pull requests
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.get 'user-name', 'repo-name', 'comment-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :comment_id])

      get_request("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", arguments.params)
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
    def create(*args)
      arguments(args, :required => [:user, :repo, :request_id]) do
        sift VALID_REQUEST_COM_PARAM_NAMES
      end
      # _validate_reply_to(params)

      post_request("/repos/#{user}/#{repo}/pulls/#{request_id}/comments", arguments.params)
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
    def edit(*args)
      arguments(args, :required => [:user, :repo, :comment_id]) do
        sift VALID_REQUEST_COM_PARAM_NAMES
      end

      patch_request("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", arguments.params)
    end

    # Delete a pull request comment
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.comments.delete 'user-name', 'repo-name','comment-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :comment_id])

      delete_request("/repos/#{user}/#{repo}/pulls/comments/#{comment_id}", arguments.params)
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
