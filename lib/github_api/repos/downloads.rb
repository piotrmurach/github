# encoding: utf-8

module Github
  class Repos
    module Downloads

      REQUIRED_PARAMS = %w[ name size ]

      VALID_DOWNLOAD_PARAM_NAMES = %w[
        name
        size
        description
        content_type
      ].freeze

      REQUIRED_S3_PARAMS = %w[
        path
        acl
        name
        accesskeyid
        policy
        signature
        mime_type
      ].freeze

      # Status code for successful upload to Amazon S3 service
      SUCCESS_STATUS = 201

      # List downloads for a repository
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.downloads 'user-name', 'repo-name'
      #  @github.repos.downloads 'user-name', 'repo-name' { |downl| ... }
      #
      def downloads(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/downloads")
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_downloads :downloads
      alias :get_downloads :downloads

      # Get a single download
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.download 'user-name', 'repo-name'
      #
      def download(user_name, repo_name, download_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of download_id
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/downloads/#{download_id}")
      end
      alias :get_download :download

      # Delete download from a repository
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.delete_download 'user-name', 'repo-name', 'download-id'
      #
      def delete_download(user_name, repo_name, download_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of download_id
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/downloads/#{download_id}")
      end

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
      #  @github = Github.new
      #  @github.repos.create_download 'user-name', 'repo-name',
      #    "name" =>  "new_file.jpg",
      #    "size" => 114034,
      #    "description" => "Latest release",
      #    "content_type" => "text/plain"
      #
      def create_download(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys(params)
        _filter_params_keys(VALID_DOWNLOAD_PARAM_NAMES, params)

        raise ArgumentError, "Required parameters are: #{REQUIRED_PARAMS.join(', ')}" unless _validate_inputs(REQUIRED_PARAMS, params)

        post("/repos/#{user}/#{repo}/downloads", params)
      end

      # Upload a file to Amazon, using the reponse instance from
      # Github::Repos::Downloads#create_download. This can be done by passing
      # the response object as an argument to upload method.
      #
      # = Parameters
      # * <tt>resource</tt> - Required Hashie::Mash -resource of the create_download call
      # * <tt>:size</tt> - Required number - size of file in bytes.
      #
      def upload(resource, filename)
        _validate_presence_of resource, filename
        raise ArgumentError, 'Need to provied resource of Github::Repose::Downloads#create_download call' unless resource.is_a? Hashie::Mash

        REQUIRED_S3_PARAMS.each do |key|
          raise ArgumentError, "Expected following key: #{key}" unless resource.respond_to?(key)
        end

        # TODO use ordered hash if Ruby < 1.9
        hash = ruby_18 {
          require 'active_support'
          ActiveSupport::OrderedHash.new } || ruby_19 { Hash.new }

        mapped_params = {
          'key'                   => resource.path,
          'acl'                   => resource.acl,
          'success_action_status' => SUCCESS_STATUS,
          'Filename'              => resource.name,
          'AWSAccessKeyId'        => resource.accesskeyid,
          'Policy'                => resource.policy,
          'Signature'             => resource.signature,
          'Content-Type'          => resource.mime_type,
          'file'                  => prepend_at_for(filename.to_s)
        }

        post('', mapped_params, { :url => resource.s3_url })
      end
      alias :upload_to_s3 :upload
      alias :upload_to_amazon :upload

    private

      def prepend_at_for(file)
        /^@.*/ =~ file ? '@' + file : file
      end

    end # Downloads
  end # Repos
end # Github
