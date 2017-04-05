# frozen_string_literal: true

module Github
  # Projects API
  class Client::Projects < API
    OPTIONS = {
      headers: {
        ACCEPT => 'application/vnd.github.inertia-preview+json'
      }
    }

    # Get properties for a single project
    #
    # @see https://developer.github.com/v3/projects/#get-a-project
    #
    # @example
    #  github = Github.new
    #  github.projects.get 1002604
    #
    # @api public
    def get(*args)
      arguments(args, required: [:id])

      params = arguments.params
      params['options'] = OPTIONS

      get_request("/projects/#{arguments.id}", params)
    end
    alias_method :find, :get
  end # Projects
end # Github
