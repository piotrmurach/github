# encoding: utf-8
# frozen_string_literal: true

require_relative '../api'

module Github
  # Projects API
  class Client::Projects < API
    PREVIEW_MEDIA = "application/vnd.github.inertia-preview+json" # :nodoc:

    require_all 'github_api/client/projects',
                'columns',
                'cards'

    # Access to Projects::Columns API
    namespace :columns

    # Access to Projects::Cards API
    namespace :cards

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

      params["accept"] ||= PREVIEW_MEDIA

      get_request("/projects/#{arguments.id}", params)
    end
    alias find get

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

      params["accept"] ||= PREVIEW_MEDIA

      patch_request("/projects/#{arguments.id}", params)
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

      params["accept"] ||= PREVIEW_MEDIA

      delete_request("/projects/#{arguments.id}", arguments.params)
    end
    alias remove delete
  end # Projects
end # Github
