# encoding: utf-8

require_relative '../../../api'

module Github
  # The Branch Protections API
  class Client::Repos::Branches::Protections < API
    VALID_PROTECTION_PARAM_NAMES = %w[
      required_status_checks
      required_pull_request_reviews
      enforce_admins
      restrictions
      accept
    ].freeze

    # Get a single branch's protection
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.protections.get 'user', 'repo', 'branch'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :branch])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/branches/#{arguments.branch}/protection", arguments.params)
    end
    alias :find :get

    # Edit a branch protection
    #
    # Users with push access to the repository can edit a branch protection.
    #
    # @param [Hash] params
    # @input params [String] :required_status_checks
    #   Required.
    # @input params [String] :enforce_admins
    #   Required.
    # @input params [String] :restrictions
    #   Required.
    # @input params [String] :required_pull_request_reviews
    #   Required.
    # Look to the branch protection API to see how to use these
    # https://developer.github.com/v3/repos/branches/#update-branch-protection
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.protections.edit 'user', 'repo', 'branch',
    #     required_pull_request_reviews: {dismiss_stale_reviews: false}
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:user, :repo, :branch]) do
        permit VALID_PROTECTION_PARAM_NAMES
      end

      put_request("/repos/#{arguments.user}/#{arguments.repo}/branches/#{arguments.branch}/protection", arguments.params)
    end
    alias :update :edit

    # Delete a branch protection
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.protections.delete 'user', 'repo', 'branch'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :branch])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/branches/#{arguments.branch}/protection", arguments.params)
    end
    alias :remove :delete
  end # Client::Repos::Branches::Protections
end # Github
