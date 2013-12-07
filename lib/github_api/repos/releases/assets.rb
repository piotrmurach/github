# encoding: utf-8

module Github

  # The Release Assets API
  class Repos::Releases::Assets < API

    VALID_ASSET_PARAM_NAMES = %w[
      name
      label
      content_type
    ].freeze # :nodoc:

    # List assets for a release
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.list 'owner', 'repo', 'id'
    #  github.repos.releases.assets.list 'owner', 'repo', 'id' { |asset| ... }
    #
    def list(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      response = get_request("/repos/#{owner}/#{repo}/releases/#{id}/assets", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single release asset
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.get 'owner', 'repo', 'id'
    #
    def get(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      get_request("/repos/#{owner}/#{repo}/releases/assets/#{id}" , params)
    end
    alias :find :get

    # Upload a release asset
    #
    # = Inputs
    # * <tt>:name</tt> - Required string - The file name of the asset
    # * <tt>:content_type</tt> - Required string - The content type
    #                            of the asset. Example: “application/zip”.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.upload 'owner', 'repo', 'id', 'file-path'
    #    "name": "batman.jpg",
    #    "content_type": "application/octet-stream"
    #
    def upload(*args)
      arguments(args, required: [:owner, :repo, :id, :filepath]) do
        sift VALID_ASSET_PARAM_NAMES
      end
      params = arguments.params

      unless type = params['content_type']
        type = infer_media(filepath)
      end

      file = Faraday::UploadIO.new(filepath, type)
      options = {
        headers: { content_type: type },
        endpoint: 'https://uploads.github.com',
        query: {'name' => params['name']}
      }
      params['data']    = file.read
      params['options'] = options

      post_request("/repos/#{owner}/#{repo}/releases/#{id}/assets", params)
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
    # = Inputs
    # * <tt>:name</tt>  - Required string - the filename of the asset
    # * <tt>:label</tt> - Optional string - An alternate short description of
    #                     the asset. Used in place of the filename.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.edit 'owner', 'repo', 'id',
    #    "name": "foo-1.0.0-osx.zip",
    #    "label": "Mac binary"
    #
    def edit(*args)
      arguments(args, required: [:owner, :repo, :id]) do
        sift VALID_ASSET_PARAM_NAMES
      end
      params = arguments.params

      patch_request("/repos/#{owner}/#{repo}/releases/assets/#{id}", params)
    end
    alias :update :edit

    # Delete a release asset
    #
    # = Examples
    #  github = Github.new
    #  github.repos.releases.assets.delete 'owner', 'repo', 'id'
    #
    def delete(*args)
      params = arguments(args, required: [:owner, :repo, :id]).params

      delete_request("/repos/#{owner}/#{repo}/releases/assets/#{id}", params)
    end

  end # Repos::Statuses
end # Github
