# encoding: utf-8

require 'github_api/s3_uploader'

module Github
  class Repos::Downloads < API

    REQUIRED_PARAMS = %w[ name size ].freeze

    VALID_DOWNLOAD_PARAM_NAMES = %w[
      name
      size
      description
      content_type
    ].freeze

    # List downloads for a repository
    #
    # = Examples
    #  github = Github.new
    #  github.repos.downloads.list 'user-name', 'repo-name'
    #  github.repos.downloads.list 'user-name', 'repo-name' { |downl| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/repos/#{user}/#{repo}/downloads", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single download
    #
    # = Examples
    #  github = Github.new
    #  github.repos.downloads.get 'user-name', 'repo-name', 'download-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :download_id])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/downloads/#{download_id}", params)
    end
    alias :find :get

    # Delete download from a repository
    #
    # = Examples
    #  github = Github.new
    #  github.repos.downloads.delete 'user-name', 'repo-name', 'download-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :download_id])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/downloads/#{download_id}", params)
    end
    alias :remove :delete

    # Creating a new download is a two step process.
    # You must first create a new download resource using this method.
    # Response from this method is to be used in #upload method.
    #
    # = Inputs
    # * <tt>:name</tt> - Required string - name of the file that is being created.
    # * <tt>:size</tt> - Required number - size of file in bytes.
    # * <tt>:description</tt> - Optional string
    # * <tt>:content_type</tt> - Optional string
    #
    # = Examples
    #  github = Github.new
    #  github.repos.downloads.create 'user-name', 'repo-name',
    #    "name" =>  "new_file.jpg",
    #    "size" => 114034,
    #    "description" => "Latest release",
    #    "content_type" => "text/plain"
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_DOWNLOAD_PARAM_NAMES
        assert_required REQUIRED_PARAMS
      end
      params = arguments.params

      post_request("/repos/#{user}/#{repo}/downloads", params)
    end

    # Upload a file to Amazon, using the reponse instance from
    # Github::Repos::Downloads#create_download. This can be done by passing
    # the response object as an argument to upload method.
    #
    # = Parameters
    # * <tt>resource</tt> - Required resource of the create_download call.
    # * <tt>:filename</tt> - Required filename, a path to a file location.
    #
    # = Examples
    #  resource = github.repos.downloads.create 'user-name', 'repo-name'
    #
    #  github.repos.downloads.upload resource, '/users/octokit/image.jpg'
    #
    def upload(*args)
      arguments(args, :required => [:resource, :filename])

      response = Github::S3Uploader.new(resource, filename).send
      response.body
    end
    alias :upload_to_s3 :upload
    alias :upload_to_amazon :upload

  end # Repos::Downloads
end # Github
