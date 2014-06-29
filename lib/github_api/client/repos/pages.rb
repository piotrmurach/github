# encoding: utf-8

module Github
  # The Pages API retrieves information about your GitHub Pages configuration,
  # and the statuses of your builds. Information about the site and the builds
  # can only be accessed by authenticated owners, even though the websites
  # are public.
  class Client::Repos::Pages < API

    # List Pages builds
    #
    # @example
    #  github = Github.new
    #  github.repos.pages.list owner: 'owner-name', repo: 'repo-name'
    #
    #  github = Github.new
    #  github.repos.pages.list :latest, owner: 'owner-name', repo: 'repo-name'
    # @api public
    def list(*args)
      arguments(args, required: [:owner, :repo])

      response = if args.map(&:to_s).include?('latest')
        get_request("/repos/#{arguments.owner}/#{arguments.repo}/pages/builds/latest", arguments.params)
      else
        get_request("/repos/#{arguments.owner}/#{arguments.repo}/pages/builds", arguments.params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get information about a Pages site
    #
    # @example
    #  github = Github.new
    #  github.repos.pages.get owner: 'owner-name', repo: 'repo-name'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:owner, :repo])

      get_request("/repos/#{arguments.owner}/#{arguments.repo}/pages", arguments.params)
    end
    alias :find :get
  end # Client::Repos::Pages
end # Github
