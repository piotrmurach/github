# frozen_string_literal: true
# encoding: utf-8

require_relative '../../api'

module Github
  class Client::Projects::Cards < API
    REQUIRED_MOVE_CARD_PARAMS = %w(position).freeze

    # List project cards for a column
    #
    # @example
    #  github = Github.new
    #  github.projects.cards.list :column_id
    #
    # @see https://developer.github.com/v3/projects/cards/#list-project-cards
    #
    # @api public
    def list(*args)
      arguments(args, required: [:column_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      response = get_request("/projects/columns/#{arguments.column_id}/cards", params)

      return response unless block_given?
      response.each { |el| yield el }
    end
    alias all list

    # Get a project card
    #
    # @example
    #  github = Github.new
    #  github.projects.cards.get :card_id
    #
    # @see https://developer.github.com/v3/projects/cards/#get-a-project-card
    #
    # @api public
    def get(*args)
      arguments(args, required: [:card_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      get_request("/projects/columns/cards/#{arguments.card_id}", params)
    end
    alias find get

    # Create a project card for a column
    #
    # @param [Hash] params
    # @option params [String] :note
    #  The card's note content. Only valid for cards without another type of
    #  content, so this must be omitted if content_id and content_type are
    #  specified.
    # @option params [Integer] :content_id
    #  The id of the Issue to associate with this card.
    # @option params [String] :content_type
    #  The type of content to associate with this card. Can only be "Issue" at
    #  this time.
    #
    # @example
    #  github = Github.new
    #  github.projects.cards.create :column_id, note: 'Card Note'
    #
    # @example
    #   github = Github.new
    #   github.projects.cards.create :column_id, content_id: <content-id>, content_type: 'content-type'
    #
    # @see https://developer.github.com/v3/projects/cards/#create-a-project-card
    #
    # @api public
    def create(*args)
      arguments(args, required: [:column_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      post_request("/projects/columns/#{arguments.column_id}/cards", params)
    end

    # Update a project card
    #
    # @param [Hash] params
    # @option params [String] :note
    #   The card's note content. Only valid for cards without another type of
    #   content, so this cannot be specified if the card already has a
    #   content_id and content_type.
    #
    # @example
    #   github = Github.new
    #   github.projects.cards.update :card_id, note: 'New card note'
    #
    # @see https://developer.github.com/v3/projects/cards/#update-a-project-card
    #
    # @api public
    def update(*args)
      arguments(args, required: [:card_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      patch_request("/projects/columns/cards/#{arguments.card_id}", params)
    end
    alias edit update

    # Delete a project card
    #
    # @example
    #   github = Github.new
    #   github.projects.cards.delete :card_id
    #
    # @see https://developer.github.com/v3/projects/cards/#delete-a-project-card
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:card_id])
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      delete_request("/projects/columns/cards/#{arguments.card_id}", params)
    end
    alias remove delete

    # Move a project card
    #
    # @param [Hash] params
    # @option params [String] :position
    #   Required. Required. Can be one of 'first', 'last', or
    #   'after:<column-id>', where <column-id> is the id value of a column in
    #   the same project.
    #
    # @example
    #  github = Github.new
    #  github.projects.cards.move :card_id, position: 'bottom'
    #
    # @example
    #  github = Github.new
    #  github.projects.cards.move :card_id, position: 'after:<card-id>', column_id: <column-id>
    #
    # @see https://developer.github.com/v3/projects/cards/#move-a-project-card
    #
    # @api public
    def move(*args)
      arguments(args, required: [:card_id]) do
        assert_required REQUIRED_MOVE_CARD_PARAMS
      end
      params = arguments.params

      params["accept"] ||= ::Github::Client::Projects::PREVIEW_MEDIA

      post_request("/projects/columns/cards/#{arguments.card_id}/moves", params)
    end
  end
end
