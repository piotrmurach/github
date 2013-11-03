# encoding: utf-8

module Github

  # The Releases API
  class Repos::Releases::Assets < API

    VALID_ASSET_PARAM_NAMES = %w[
      name
      label
    ].freeze # :nodoc:

    # List assets for a release
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.list 'owner', 'repo', 'id'
    #  github.repos.releases.assets.list 'owner', 'repo', 'id' { |asset| ... }
    #
    def list(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      response = get_request("/repos/#{owner}/#{repo}/releases/#{id}/assets", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single release asset
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.get 'owner', 'repo', 'id'
    #
    def get(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      get_request("/repos/#{owner}/#{repo}/releases/assets/#{id}" , params)
    end
    alias :find :get

  end # Repos::Statuses
end # Github
