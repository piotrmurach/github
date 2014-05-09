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
    # = Examples
    #  github = Github.new
    #  github.repos.deployments.list 'user-name', 'repo-name'
    #  github.repos.deployments.list 'user-name', 'repo-name' { |deployment| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      response = get_request("repos/#{user}/#{repo}/deployments", params)
      return response unless block_given?

      response.each { |el| yield el }
    end
    alias :all :list

    # List commits on a repository
    #
    # = Parameters
    # * <tt>:ref</tt>         Required string. Sha or branch to start listing commits from.
    # * <tt>:force</tt>       Optional boolean. Ignore commit status checks.
    # * <tt>:payload</tt>     Optional string. Optional json payload with information about the deployment.
    # * <tt>:auto_merge</tt>  Optional boolean. Merge the default branch into the requested deployment branch if necessary.
    # * <tt>:description</tt> Optional string. Optional short description.
    # = Examples
    #  github = Github.new
    #  github.repos.deployments.create 'user-name', 'repo-name', :ref => '...'
    #  github.repos.deployments.create
    #     'user-name',
    #     'repo-name',
    #     ref: '...',
    #     description: 'New deploy',
    #     force: true
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_DEPLOYMENTS_OPTIONS
        assert_required %w[ ref ]
      end

      params = arguments.params
      params['accept'] ||= PREVIEW_MEDIA

      post_request("repos/#{user}/#{repo}/deployments", params)
    end

  end # Client::Repos::Deployments
end
