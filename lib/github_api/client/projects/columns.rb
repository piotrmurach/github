# frozen_string_literal: true
# encoding: utf-8

module Github
  class Client::Projects::Columns < API
    REQUIRED_COLUMN_PARAMS = %w(name).freeze
    REQUIRED_MOVE_COLUMN_PARAMS = %w(position).freeze

    require_all 'github_api/client/projects/columns',
                'cards'

    # Access to Projects::Cards API
    namespace :cards

    # List a project's columns
    #
    # @example
    #  github = Github.new
    #  github.projects.columns.list :project_id
    #
    # @see https://developer.github.com/v3/projects/columns/#list-project-columns
    #
    # @api public
    def list(*args)
      arguments(args, required: [:project_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      get_request("/projects/#{arguments.project_id}/columns", params)
    end
    alias all list

    # Get a project columns
    #
    # @example
    #  github = Github.new
    #  github.projects.columns.get :column_id
    #
    # @see https://developer.github.com/v3/projects/columns/#get-a-project-column
    #
    # @api public
    def get(*args)
      arguments(args, required: [:column_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      get_request("/projects/columns/#{arguments.column_id}", params)
    end
    alias find get

    # Create a project column
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Required. The name of the column.
    #
    # @example
    #  github = Github.new
    #  github.projects.columns.create :project_id, name: 'column-name'
    #
    # @see https://developer.github.com/v3/projects/columns/#create-a-project-column
    #
    # @api public
    def create(*args)
      arguments(args, required: [:project_id]) do
        assert_required REQUIRED_COLUMN_PARAMS
      end
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      post_request("/projects/#{arguments.project_id}/columns", params)
    end

    # Update a project column
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Required. The name of the column.
    #
    # @example
    #   github = Github.new
    #   github.repos.projects.update :column_id, name: 'new-column-name'
    #
    # @see https://developer.github.com/v3/projects/columns/#update-a-project-column
    #
    # @api public
    def update(*args)
      arguments(args, required: [:column_id]) do
        assert_required REQUIRED_COLUMN_PARAMS
      end
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      patch_request("/projects/columns/#{arguments.column_id}", params)
    end
    alias edit update

    # Delete a project column
    #
    # @example
    #   github = Github.new
    #   github.projects.columns.delete :column_id
    #
    # @see https://developer.github.com/v3/projects/columns/#delete-a-project-column
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:column_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      delete_request("/projects/columns/#{arguments.column_id}", params)
    end
    alias remove delete

    # Move a project column
    #
    # @param [Hash] params
    # @option params [String] :position
    #   Required. Required. Can be one of 'first', 'last', or
    #   'after:<column-id>', where <column-id> is the id value of a column in
    #   the same project.
    #
    # @example
    #  github = Github.new
    #  github.projects.columns.move :column_id, position: 'first'
    #
    # @see https://developer.github.com/v3/projects/columns/#move-a-project-column
    #
    # @api public
    def move(*args)
      arguments(args, required: [:column_id]) do
        assert_required REQUIRED_MOVE_COLUMN_PARAMS
      end
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      post_request("/projects/columns/#{arguments.column_id}/moves", params)
    end
  end
end
