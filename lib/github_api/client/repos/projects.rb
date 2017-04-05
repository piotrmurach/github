# frozen_string_literal: true

module Github
  class Client::Repos::Projects < API
    OPTIONS = {
      headers: {
        ACCEPT => 'application/vnd.github.inertia-preview+json'
      }
    }

    # List a repo's projects
    #
    # @example
    #  github = Github.new
    #  github.repos.projects.list owner: 'owner-name', repo: 'repo-name'
    #
    # @example
    #  github = Github.new
    #  github.repos.projects.list state: 'open', owner: 'owner-name', repo: 'repo-name'
    #
    # @example
    #  github.repos.projects.list owner: 'owner-name', repo: 'repo-name' { |cbr| .. }
    #
    # @return [Array]
    #
    # @api public
    def list(*args)
      arguments(args, required: [:owner, :repo])

      params = arguments.params
      params['options'] = OPTIONS

      response = get_request("/repos/#{arguments.owner}/#{arguments.repo}/projects", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list
  end
end
