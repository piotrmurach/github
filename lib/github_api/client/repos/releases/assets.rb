# encoding: utf-8

module Github
  # The Release Assets API
  class Client::Repos::Releases::Assets < API

    VALID_ASSET_PARAM_NAMES = %w[
      name
      label
      content_type
    ].freeze # :nodoc:

    # List assets for a release
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.assets.list 'owner', 'repo', 'id'
    #   github.repos.releases.assets.list 'owner', 'repo', 'id' { |asset| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:owner, :repo, :id]).params

      response = get_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/#{arguments.id}/assets", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single release asset
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.assets.get 'owner', 'repo', 'id'
    #
    # @api public
    def get(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      get_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/assets/#{arguments.id}" , arguments.params)
    end
    alias :find :get

    # Upload a release asset
    #
    # @param [Hash] params
    # @input params [String] :name
    #   Required string. The file name of the asset
    # @input params [String] :content_type
    #   Required string. The content type of the asset.
    #   Example: “application/zip”.
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.assets.upload 'owner', 'repo', 'id', 'file-path'
    #     name: "batman.jpg",
    #     content_type: "application/octet-stream"
    #
    # @api public
    def upload(*args)
      arguments(args, required: [:owner, :repo, :id, :filepath]) do
        permit VALID_ASSET_PARAM_NAMES
      end
      params = arguments.params

      unless type = params['content_type']
        type = infer_media(arguments.filepath)
      end

      file = Faraday::UploadIO.new(arguments.filepath, type)
      options = {
        headers: { content_type: type },
        endpoint: upload_endpoint,
        query: {'name' => params['name']}
      }
      params['data']    = file.read
      params['options'] = options

      post_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/#{arguments.id}/assets", params)
    ensure
      file.close if file
    end

    # Infer media type of the asset
    #
    def infer_media(filepath)
      require 'mime/types'
      types = MIME::Types.type_for(filepath)
      types.empty? ? 'application/octet-stream' : types.first
    rescue LoadError
      raise Github::Error::UnknownMedia.new(filepath)
    end

    # Edit a release asset
    #
    # Users with push access to the repository can edit a release asset.
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
    #   github.repos.releases.assets.edit 'owner', 'repo', 'id',
    #     name: "foo-1.0.0-osx.zip",
    #     label: "Mac binary"
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:owner, :repo, :id]) do
        permit VALID_ASSET_PARAM_NAMES
      end

      patch_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/assets/#{arguments.id}", arguments.params)
    end
    alias :update :edit

    # Delete a release asset
    #
    # @example
    #   github = Github.new
    #   github.repos.releases.assets.delete 'owner', 'repo', 'id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:owner, :repo, :id])

      delete_request("/repos/#{arguments.owner}/#{arguments.repo}/releases/assets/#{arguments.id}", arguments.params)
    end
  end # Client::Repos::Releases::Assets
end # Github
