# encoding: utf-8

module Github
  class Client::PullRequests::Reviews < API
    PREVIEW_MEDIA = "application/vnd.github.black-cat-preview+json".freeze # :nodoc:

    # List reviews on a pull request
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.reviews.list 'user-name', 'repo-name', number: 'pull-request-number'
    #
    # List pull request reviews in a repository
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.reviews.list 'user-name', 'repo-name', number: 'pull-request-number'
    #   github.pull_requests.reviews.list 'user-name', 'repo-name', number: 'pull-request-number' { |comm| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo, :number])
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/reviews", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get a single review for pull requests
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.reviews.get 'user-name', 'repo-name', 'number', 'id'
    #
    # @example
    #   github.pull_requests.reviews.get
    #     user: 'user-name',
    #     repo: 'repo-name',
    #     number: 1,
    #     id: 80
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :number, :id])

      params             = arguments.params
      params["accept"] ||= PREVIEW_MEDIA

      get_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/reviews/#{arguments.id}", params)
    end
    alias_method :find, :get

    # Create a pull request review
    #
    # @param [Hash] params
    # @option params [String] :event
    #   Required string - The review action (event) to perform; can be one of
    #   APPROVE, REQUEST_CHANGES, or COMMENT. If left blank, the API returns
    #   HTTP 422 (Unrecognizable entity) and the review is left PENDING
    # @option params [String] :body
    #   Optional string. The text of the review.
    # @option params [Array] :comments
    #   Optional array of draft review comment objects. An array of comments
    #   part of the review.
    #
    # @example
    #  github = Github.new
    #  github.pull_requests.reviews.create 'user-name', 'repo-name', 'number',
    #    body: "Nice change",
    #    event: "APPROVE",
    #    comments: [
    #      {
    #        path: 'path/to/file/commented/on',
    #        position: 10,
    #        body:     'This looks good.'
    #      }
    #    ]
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :number])

      params             = arguments.params
      params["accept"] ||= PREVIEW_MEDIA

      post_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/reviews", params)
    end

    # Update a pull request review
    #
    # @param [Hash] params
    # @option params [String] :state
    #   Required string - The review action (event) to perform; can be one of
    #   APPROVE, REQUEST_CHANGES, or COMMENT. If left blank, the API returns
    #   HTTP 422 (Unrecognizable entity) and the review is left PENDING
    # @optoin params [String] :body
    #   Optional string
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.pull_requests.reviews.update 'user-name', 'repo-name', 'number', 'review-id'
    #    body: "Update body",
    #    event: "APPROVE"
    #
    # @api public
    def update(*args)
      arguments(args, required: [:user, :repo, :number, :id])
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      post_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/reviews/#{arguments.id}/events", params)
    end

    # @option params [String] :message
    #   Optional string - Reason for dismissal
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.pull_requests.reviews.dismiss 'user-name', 'repo-name', 'number', 'review-id'
    #    message: "I can't get to this right now."
    #
    # @api public
    def dismiss(*args)
      arguments(args, required: [:user, :repo, :number, :id])
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      put_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/reviews/#{arguments.id}/dismissals", params)
    end

    # List comments on a pull request review
    #
    # @example
    #  github = Github.new
    #  github.pull_requests.revieiws.comments 'user-name', 'repo-name', 'number', 'review-id'
    #
    # @api public
    def comments(*args)
      arguments(args, required: [:user, :repo, :number, :id])
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/reviews/#{arguments.id}/comments", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

  end
end
