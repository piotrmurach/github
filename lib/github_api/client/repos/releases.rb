# encoding: utf-8

module Github
  # The Releases API
  class Client::Repos::Releases < API

    require_all 'github_api/client/repos/releases', 'assets'

    VALID_RELEASE_PARAM_NAMES = %w[
      tag_name
      target_commitish
      name
      body
      draft
      prerelease
    ].freeze # :nodoc:

    # Access to Repos::Releases::Assets API
    namespace :assets

    # List releases for a repository
    #
    # Users with push access to the repository will receive all releases
    # (i.e., published releases and draft releases). Users with pull access
    # will receive published releases only.
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.list 'owner', 'repo'
    #   github.repos.releases.list 'owner', 'repo' { |release| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:owner, :repo]).params

      response = get_request("/repos/#{arguments.owner}/#{arguments.repo}/releases", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single release
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.get 'owner', 'repo', 'id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:owner, :repo, :id]).params
      get_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/#{arguments.id}" , arguments.params)
    end
    alias :find :get

    # Create a release
    #
    # @param [Hash] params
    # @input params [String] :tag_name
    #   Required. The name of the tag.
    # @input params [String] :target_commitish
    #   Specifies the commitish value that determines where the Git tag
    #   is created from. Can be any branch or commit SHA. Defaults to
    #   the repository's default branch (usually 'master').
    #   Unused if the Git tag already exists.
    # @input params [String] :name
    #   The name of the release.
    # @input params [String] :body
    #   Text describing the contents of the tag.
    # @input params [Boolean] :draft
    #   true to create a draft (unpublished) release,
    #   false to create a published one. Default: false
    # @input params [Boolean] :prerelease
    #   true to identify the release as a prerelease.
    #   false to identify the release as a full release. Default: false
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.create 'owner', 'repo', 'tag-name',
    #     tag_name: "v1.0.0",
    #     target_commitish: "master",
    #     name: "v1.0.0",
    #     body: "Description of the release",
    #     draft: false,
    #     prerelease: false
    #
    # @api public
    def create(*args)
      arguments(args, required: [:owner, :repo, :tag_name]) do
        permit VALID_RELEASE_PARAM_NAMES
      end
      params = arguments.params
      params['tag_name'] = arguments.tag_name

      post_request("/repos/#{arguments.owner}/#{arguments.repo}/releases", params)
    end

    # Edit a release
    #
    # @param [Hash] params
    # @input params [String] :tag_name
    #   Required. The name of the tag.
    # @input params [String] :target_commitish
    #   Specifies the commitish value that determines where the Git tag
    #   is created from. Can be any branch or commit SHA. Defaults to
    #   the repository's default branch (usually 'master').
    #   Unused if the Git tag already exists.
    # @input params [String] :name
    #   The name of the release.
    # @input params [String] :body
    #   Text describing the contents of the tag.
    # @input params [Boolean] :draft
    #   true to create a draft (unpublished) release,
    #   false to create a published one. Default: false
    # @input params [Boolean] :prerelease
    #   true to identify the release as a prerelease.
    #   false to identify the release as a full release. Default: false
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.edit 'owner', 'repo', 'id',
    #     tag_name: "v1.0.0",
    #     target_commitish: "master",
    #     name: "v1.0.0",
    #     body: "Description of the release",
    #     draft: false,
    #     prerelease: false
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:owner, :repo, :id]) do
        permit VALID_RELEASE_PARAM_NAMES
      end

      patch_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/#{arguments.id}", arguments.params)
    end
    alias :update :edit

    # Delete a release
    #
    # Users with push access to the repository can delete a release.
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.delete 'owner', 'repo', 'id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:owner, :repo, :id]).params

      delete_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/#{arguments.id}", arguments.params)
    end
  end # Client::Repos::Statuses
end # Github
