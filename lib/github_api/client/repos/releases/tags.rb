# encoding: utf-8

module Github
  # The Releases API
  class Client::Repos::Releases::Tags < API
    # Get a published release with the specified tag.
    #
    # @see https://developer.github.com/v3/repos/releases/#get-a-release-by-tag-name
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.tags.get 'owner', 'repo', 'tag'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:owner, :repo, :tag]).params

      get_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/tags/#{arguments.tag}" , arguments.params)
    end
    alias_method :find, :get
  end # Client::Repos::Releases::Tags
end # Github
