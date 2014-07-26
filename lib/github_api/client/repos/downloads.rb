# encoding: utf-8

module Github
  class Client::Repos::Downloads < API

    REQUIRED_PARAMS = %w[ name size ].freeze

    VALID_DOWNLOAD_PARAM_NAMES = %w[
      name
      size
      description
      content_type
    ].freeze

    # List downloads for a repository
    #
    # @example
    #   github = Github.new
    #   github.repos.downloads.list 'user-name', 'repo-name'
    #   github.repos.downloads.list 'user-name', 'repo-name' { |downl| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/downloads", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single download
    #
    # @example
    #   github = Github.new
    #   github.repos.downloads.get 'user-name', 'repo-name', 'download-id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :id])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/downloads/#{arguments.id}", arguments.params)
    end
    alias :find :get

    # Delete download from a repository
    #
    # @example
    #   github = Github.new
    #   github.repos.downloads.delete 'user-name', 'repo-name', 'download-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :id])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/downloads/#{arguments.id}", arguments.params)
    end
    alias :remove :delete
  end # Repos::Downloads
end # Github
