# encoding: utf-8

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

    # Get a single branch protection
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.protections.get 'user', 'repo', 'id'
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
    # @input params [String] :name
    #   Required. The file name of the asset.
    # @input params [String] :label
    #   An alternate short description of the asset.
    #   Used in place of the filename.
    #
    # @example
    #   github = Github.new
    #   github.repos.branches.protections.edit 'user', 'repo', 'id',
    #     name: "foo-1.0.0-osx.zip",
    #     label: "Mac binary"
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
    #   github.repos.branches.protections.delete 'user', 'repo', 'id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :branch])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/branches/#{arguments.branch}/protection", arguments.params)
    end
  end # Client::Repos::Branches::Protections
end # Github
