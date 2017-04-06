# frozen_string_literal: true

module Github
  # Projects API
  class Client::Projects < API
    HEADERS = {
      ACCEPT => 'application/vnd.github.inertia-preview+json'
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
      params['headers'] = HEADERS

      get_request("/projects/#{arguments.id}", params)
    end
    alias_method :find, :get

    # Edit a project
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Optional string
    # @option params [String] :body
    #   Optional string
    # @option params [String] :state
    #   Optional string
    #
    # @example
    #  github = Github.new
    #  github.projects.edit 1002604,
    #    name: "Outcomes Tracker",
    #    body: "The board to track work for the Outcomes application."
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:id])

      params = arguments.params
      params['headers'] = HEADERS

      patch_request("/projects/#{arguments.id}",params)
    end

    # Delete a project
    #
    # @example
    #  github = Github.new
    #  github.projects.delete 1002604
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:id])

      params = arguments.params
      params['headers'] = HEADERS

      delete_request("/projects/#{arguments.id}", arguments.params)
    end
    alias :remove :delete
  end # Projects
end # Github
