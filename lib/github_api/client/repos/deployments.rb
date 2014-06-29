# encoding: utf-8

module Github
  class Client::Repos::Deployments < API

    VALID_DEPLOYMENTS_OPTIONS = %w[
      ref
      force
      payload
      auto_merge
      description
    ]

    PREVIEW_MEDIA = 'application/vnd.github.cannonball-preview+json'.freeze # :nodoc:

    # List deployments on a repository
    #
    # @xample
    #  github = Github.new
    #  github.repos.deployments.list 'user-name', 'repo-name'
    #  github.repos.deployments.list 'user-name', 'repo-name' { |deployment| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      response = get_request("repos/#{user}/#{repo}/deployments", params)
      return response unless block_given?

      response.each { |el| yield el }
    end
    alias :all :list

    # Create a deployment
    #
    # @param [Hash] params
    # @option params [String] :ref
    #   Required string. Sha or branch to start listing commits from.
    # @option params [Boolean] :force
    #   Optional boolean. Ignore commit status checks.
    # @option params [String] :payload
    #   Optional json payload with information about the deployment.
    # @option params [Boolean] :auto_merge
    #   Optional boolean. Merge the default branch into the requested
    #   deployment branch if necessary.
    # @option params [String] :description
    #   Optional string. Optional short description.
    #
    # @example
    #  github = Github.new
    #  github.repos.deployments.create 'user-name', 'repo-name', ref: '...'
    #  github.repos.deployments.create
    #     'user-name',
    #     'repo-name',
    #     ref: '...',
    #     description: 'New deploy',
    #     force: true
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        sift VALID_DEPLOYMENTS_OPTIONS
        assert_required %w[ ref ]
      end

      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      post_request("repos/#{user}/#{repo}/deployments", params)
    end

    # List the statuses of a deployment.
    #
    # @param [Hash] params
    # @option params [String] :id
    #   Required string. Id of the deployment being queried.
    #
    # @example
    #  github = Github.new
    #  github.repos.deployments.statuses 'user-name', 'repo-name', DEPLOYMENT_ID
    #  github.repos.deployments.statuses 'user-name', 'repo-name', DEPLOYMENT_ID { |status| ... }
    #
    # @api public
    def statuses(*args)
      arguments(args, required: [:user, :repo, :id])

      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      statuses = get_request("repos/#{user}/#{repo}/deployments/#{id}/statuses", params)
      return statuses unless block_given?
      statuses.each { |status| yield status }
    end

    # Create a deployment status
    #
    # @param [Hash] params
    # @option params [String] :id
    #   Required string. Id of the deployment being referenced.
    # @option params [String] :state
    #   Required string. State of the deployment. Can be one of:
    #   pending, success, error, or failure.
    # @option params [String] :target_url
    #   Optional string. The URL associated with the status.
    # @option params [String] :description
    #   Optional string. A short description of the status.
    #
    # @example
    #  github = Github.new
    #  github.repos.deployments.create_status 'user-name', 'repo-name', DEPLOYMENT_ID, state: '...'
    #
    # @api public
    def create_status(*args)
      arguments(args, required: [:user, :repo, :id]) do
        assert_required %w[ state ]
      end

      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      post_request("repos/#{user}/#{repo}/deployments/#{id}/statuses", params)
    end
  end # Client::Repos::Deployments
end # Github
