# encoding: utf-8

module Github

  # The Pages API retrieves information about your GitHub Pages configuration,
  # and the statuses of your builds. Information about the site and the builds
  # can only be accessed by authenticated owners, even though the websites
  # are public.
  class Repos::Pages < API

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
      params = arguments.params

      response = if args.map(&:to_s).include?('latest')
        get_request("/repos/#{owner}/#{repo}/pages/builds/latest")
      else
        get_request("/repos/#{owner}/#{repo}/pages/builds")
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

      get_request("/repos/#{owner}/#{repo}/pages", arguments.params)
    end
    alias :find :get

  end # Pages
end # Github
