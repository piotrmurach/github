# encoding: utf-8

module Github

  # The Releases API
  class Repos::Releases < API

    Github::require_all 'github_api/repos/releases', 'assets'

    VALID_RELEASE_PARAM_NAMES = %w[
      tag_name
      target_commitish
      name
      body
      draft
      prerelease
    ].freeze # :nodoc:

    # Access to Repos::Releases::Assets API
    def assets(options = {}, &block)
      @assets ||= ApiFactory.new('Repos::Releases::Assets', current_options.merge(options), &block)
    end

    # List releases for a repository
    #
    # Users with push access to the repository will receive all releases
    # (i.e., published releases and draft releases). Users with pull access
    # will receive published releases only.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.list 'owner', 'repo'
    #  github.repos.releases.list 'owner', 'repo' { |release| ... }
    #
    def list(*args)
      params = arguments(args, required: [:owner, :repo]).params
      response = get_request("/repos/#{owner}/#{repo}/releases", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single release
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.get 'owner', 'repo', 'id'
    #
    def get(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params
      get_request("/repos/#{owner}/#{repo}/releases/#{id}" , params)
    end
    alias :find :get

    # Create a release
    #
    # = Inputs
    # * <tt>:tag_name</tt> - Required string
    # * <tt>:target_commitish</tt> - Optional string - Specifies the commitish
    #       value that determines where the Git tag is created from. Can be
    #       any branch or commit SHA. Defaults to the repository's default
    #       branch (usually 'master'). Unused if the Git tag already exists.
    # * <tt>:name</tt> - Optional string
    # * <tt>:body</tt> - Optional string
    # * <tt>:draft</tt> - Optional boolean - <tt>true</tt> to create a draft
    #                    (unpublished) release, <tt>false</tt> to create
    #                     a published one. Default is false.
    # * <tt>:prerelease</tt> - Optional boolean - <tt>true</tt> to identify
    #                       the release as a prerelease. false to identify
    #                       the release as a full release. Default is false.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.create 'owner', 'repo', 'tag-name',
    #    "tag_name": "v1.0.0",
    #    "target_commitish": "master",
    #    "name": "v1.0.0",
    #    "body": "Description of the release",
    #    "draft": false,
    #    "prerelease": false
    #
    def create(*args)
      arguments(args, required: [:owner, :repo, :tag_name]) do
        sift VALID_RELEASE_PARAM_NAMES
      end
      params = arguments.params
      params['tag_name'] = tag_name

      post_request("/repos/#{owner}/#{repo}/releases", params)
    end

    # Edit a release
    #
    # = Inputs
    # * <tt>:tag_name</tt> - Required string
    # * <tt>:target_commitish</tt> - Optional string - Specifies the commitish
    #       value that determines where the Git tag is created from. Can be
    #       any branch or commit SHA. Defaults to the repository's default
    #       branch (usually 'master'). Unused if the Git tag already exists.
    # * <tt>:name</tt> - Optional string
    # * <tt>:body</tt> - Optional string
    # * <tt>:draft</tt> - Optional boolean - <tt>true</tt> to create a draft
    #                    (unpublished) release, <tt>false</tt> to create
    #                     a published one. Default is false.
    # * <tt>:prerelease</tt> - Optional boolean - <tt>true</tt> to identify
    #                       the release as a prerelease. false to identify
    #                       the release as a full release. Default is false.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.edit 'owner', 'repo', 'id',
    #    "tag_name": "v1.0.0",
    #    "target_commitish": "master",
    #    "name": "v1.0.0",
    #    "body": "Description of the release",
    #    "draft": false,
    #    "prerelease": false
    #
    def edit(*args)
      arguments(args, required: [:owner, :repo, :id]) do
        sift VALID_RELEASE_PARAM_NAMES
      end
      params = arguments.params

      patch_request("/repos/#{owner}/#{repo}/releases/#{id}", params)
    end
    alias :update :edit

    # Delete a release
    #
    # Users with push access to the repository can delete a release.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.delete 'owner', 'repo', 'id'
    #
    def delete(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      delete_request("/repos/#{owner}/#{repo}/releases/#{id}", params)
    end

  end # Repos::Statuses
end # Github
