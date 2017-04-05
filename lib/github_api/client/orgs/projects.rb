# frozen_string_literal: true

module Github
  class Client::Orgs::Projects < API
    OPTIONS = {
      headers: {
        ACCEPT => 'application/vnd.github.inertia-preview+json'
      }
    }

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
      params['options'] = OPTIONS

      response = get_request("/orgs/#{arguments.org_name}/projects", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list
  end # Projects
end # Github
