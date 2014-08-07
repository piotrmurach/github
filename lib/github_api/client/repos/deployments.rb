# encoding: utf-8

module Github
  class Client::Repos::Deployments < API

    VALID_DEPLOYMENTS_OPTIONS = %w[
      ref
      auto_merge
      required_contexts
      payload
      environment
      description
    ]

    VALID_STATUS_OPTIONS = %w[
      state
      target_url
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

      response = get_request("repos/#{arguments.user}/#{arguments.repo}/deployments", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Create a deployment
    #
    # @param [Hash] params
    # @option params [String] :ref
    #   Required string. The ref to deploy. This can be a branch, tag, or sha.
    # @option params [Boolean] :auto_merge
    #   Optional boolean. Merge the default branch into the requested.
    # @option params [Array] :required_contexts
    #   Optional array of status contexts verified against commit status checks.
    #   If this parameter is omitted from the parameters then all unique
    #   contexts will be verified before a deployment is created. To bypass
    #   checking entirely pass an empty array. Defaults to all unique contexts.
    # @option params [String] :payload
    #   Optional JSON payload with extra information about the deployment.
    #   Default: ""
    # @option params [String] :payload
    #   Optional String. Name for the target deployment environment (e.g.,
    #   production, staging, qa). Default: "production"
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
        permit VALID_DEPLOYMENTS_OPTIONS
        assert_required %w[ ref ]
      end
      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      post_request("repos/#{arguments.user}/#{arguments.repo}/deployments", arguments.params)
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

      statuses = get_request("repos/#{arguments.user}/#{arguments.repo}/deployments/#{arguments.id}/statuses", params)
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
        permit VALID_STATUS_OPTIONS
      end
      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      post_request("repos/#{arguments.user}/#{arguments.repo}/deployments/#{arguments.id}/statuses", params)
    end
  end # Client::Repos::Deployments
end # Github
