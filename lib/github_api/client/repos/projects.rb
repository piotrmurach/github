# frozen_string_literal: true

require_relative '../../api'

module Github
  class Client::Repos::Projects < API
    PREVIEW_MEDIA = "application/vnd.github.inertia-preview+json".freeze # :nodoc:

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

      params["accept"] ||= PREVIEW_MEDIA

      response = get_request("/repos/#{arguments.owner}/#{arguments.repo}/projects", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Create a new project for the specified repo
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Required string - The name of the project.
    # @option params [String] :body
    #   Optional string - The body of the project.
    #
    # @example
    #  github = Github.new
    #  github.repos.projects.create 'owner-name', 'repo-name', name: 'project-name'
    #  github.repos.projects.create name: 'project-name', body: 'project-body', owner: 'owner-name', repo: 'repo-name'
    #
    # @api public
    def create(*args)
      arguments(args, required: [:owner, :repo]) do
        assert_required %w[ name ]
      end
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      post_request("/repos/#{arguments.owner}/#{arguments.repo}/projects", params)
    end
  end # Projects
end # Github
