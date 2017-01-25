# encoding: utf-8

module Github
  class Client::PullRequests::Comments < API
    # List comments on a pull request
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.comments.list 'user-name', 'repo-name', number: 'id'
    #
    # List comments in a repository
    #
    # By default, Review Comments are ordered by ascending ID.
    #
    # @param [Hash] params
    # @input params [String] :sort
    #   Optional string. Can be either created or updated. Default: created
    # @input params [String] :direction
    #   Optional string. Can be either asc or desc. Ignored without sort parameter
    # @input params [String] :since
    #   Optional string of a timestamp in ISO 8601
    #                         format: YYYY-MM-DDTHH:MM:SSZ
    # @example
    #   github = Github.new
    #   github.pull_requests.comments.list 'user-name', 'repo-name'
    #   github.pull_requests.comments.list 'user-name', 'repo-name' { |comm| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params
      user = arguments.user
      repo = arguments.repo

      response = if (number = params.delete('number'))
        get_request("/repos/#{user}/#{repo}/pulls/#{number}/comments", params)
      else
        get_request("/repos/#{user}/#{repo}/pulls/comments", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get a single comment for pull requests
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.comments.get 'user-name', 'repo-name', 'number'
    #
    # @example
    #   github.pull_requests.comments.get
    #     user: 'user-name',
    #     repo: 'repo-name',
    #     number: 'comment-number
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :number])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/comments", arguments.params)
    end
    alias_method :find, :get

    # Create a pull request comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required string. The text of the comment.
    # @option params [String] :commit_id
    #   Required string - The SHA of the commit to comment on.
    # @option params [String] :path
    #   Required string. The relative path of the file to comment on.
    # @option params [Number] :position
    #   Required number. The line index in the diff to comment on.
    #
    # @example
    #  github = Github.new
    #  github.pull_requests.comments.create 'user-name', 'repo-name', 'number',
    #    body: "Nice change",
    #    commit_id: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    #    path: "file1.txt",
    #    position: 4
    #
    # Alternative Inputs
    #
    # Instead of passing commit_id, path, and position you can reply to
    # an existing Pull Request Comment like this
    # @option params [String] :body
    #   Required string. The text of the comment.
    # @option params [Number] :in_reply_to
    #   Required number. The comment id to reply to.
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.comments.create 'user-name','repo-name', 'number',
    #     body: "Nice change",
    #     in_reply_to: 4
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :number])

      post_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/comments", arguments.params)
    end

    # Edit a pull request comment
    #
    # @param [Hash] params
    # @option params [String] :body
    #   Required string. The text of the comment.
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.comments.edit 'user-name', 'repo-name', 'number',
    #     body: "Nice change"
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:user, :repo, :number])

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/comments/#{arguments.number}", arguments.params)
    end

    # Delete a pull request comment
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.comments.delete 'user-name', 'repo-name', 'number'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :number])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/comments/#{arguments.number}", arguments.params)
    end
  end # PullRequests::Comments
end # Github
