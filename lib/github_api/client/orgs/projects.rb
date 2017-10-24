# frozen_string_literal: true

require_relative '../../api'

module Github
  class Client::Orgs::Projects < API
    PREVIEW_MEDIA = "application/vnd.github.inertia-preview+json".freeze # :nodoc:

    # List your organization projects
    #
    # @see List your organization projects
    #
    # @example
    #   github = Github.new 'org-name'
    #   github.orgs.projects.list 'org-name' { |project| ... }
    #
    # @example
    #  github = Github.new
    #  github.orgs.projects.list 'org-name', state: 'closed'
    #
    # @api public
    def list(*args)
      arguments(args, required: [:org_name])
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      response = get_request("/orgs/#{arguments.org_name}/projects", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

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
    #  github.repos.create 'owner-name', 'repo-name', name: 'project-name'
    #  github.repos.create name: 'project-name', body: 'project-body', owner: 'owner-name', repo: 'repo-name'
    def create(*args)
      arguments(args, required: [:org_name]) do
        assert_required %w[ name ]
      end
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      post_request("/orgs/#{arguments.org_name}/projects", params)
    end
  end # Projects
end # Github
