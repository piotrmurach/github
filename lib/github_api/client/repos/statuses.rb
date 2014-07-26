# encoding: utf-8

module Github
  # The Status API allows external services to mark commits with a success,
  # failure, error, or pending state, which is then reflected in pull requests
  # involving those commits.
  class Client::Repos::Statuses < API

    VALID_STATUS_PARAM_NAMES = %w[
      state
      target_url
      description
      context
    ].freeze # :nodoc:

    REQUIRED_PARAMS = %w[ state ].freeze # :nodoc:

    # List Statuses for a specific SHA
    #
    # @param [String] :ref
    #   Ref to fetch the status for. It can be a SHA, a branch name,
    #   or a tag name.
    #
    # @example
    #   github = Github.new
    #   github.repos.statuses.list 'user-name', 'repo-name', 'ref'
    #   github.repos.statuses.list 'user-name', 'repo-name', 'ref' { |status| ... }
    #
    # Get the combined Status for a specific Ref
    #
    # @example
    #   github = Github.new
    #   github.repos.statuses.list 'user', 'repo', 'ref', combined: true
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo, :ref])
      params = arguments.params
      user, repo, ref = arguments.user, arguments.repo, arguments.ref

      response = if params.delete('combined')
        get_request("/repos/#{user}/#{repo}/commits/#{ref}/status", params)
      else
        get_request("/repos/#{user}/#{repo}/commits/#{ref}/statuses", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Create a status
    #
    # @param [Hash] params
    # @input params [String] :state
    #   Required. The state of the status. Can be one of pending,
    #   success, error, or failure.
    # @input params [String] :target_url
    #   The target URL to associate with this status. This URL will
    #   be linked from the GitHub UI to allow users to easily see
    #   the ‘source’ of the Status.
    #
    #   For example, if your Continuous Integration system is posting
    #   build status, you would want to provide the deep link for
    #   the build output for this specific SHA:
    #   http://ci.example.com/user/repo/build/sha.
    # @input params [String] :description
    #   A short description of the status
    # @input params [String] :context
    #   A string label to differentiate this status from the
    #   status of other systems. Default: "default"
    #
    # @example
    #   github = Github.new
    #   github.repos.statuses.create 'user-name', 'repo-name', 'sha',
    #     state:  "success",
    #     target_url: "http://ci.example.com/johndoe/my-repo/builds/sha",
    #     description: "Successful build #3 from origin/master"
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :sha]) do
        permit VALID_STATUS_PARAM_NAMES, recursive: false
        assert_required REQUIRED_PARAMS
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/statuses/#{arguments.sha}", arguments.params)
    end
  end # Client::Repos::Statuses
end # Github
