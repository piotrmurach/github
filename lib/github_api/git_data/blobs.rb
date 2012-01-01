# encoding: utf-8

module Github
  class GitData
    # Since blobs can be any arbitrary binary data, the input and responses for
    # the blob api takes an encoding parameter that can be either utf-8 or base64.
    # If your data cannot be losslessly sent as a UTF-8 string, you can base64 encode it.
    module Blobs

      VALID_BLOB_PARAM_NAMES = %w[ content encoding ].freeze

      # Get a blob
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.blob 'user-name', 'repo-name', 'sha'
      #
      def blob(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha
        _normalize_params_keys params

        get("/repos/#{user}/#{repo}/git/blobs/#{sha}", params)
      end
      alias :get_blob :blob

      # Create a blob
      #
      # = Inputs
      # * <tt>:content</tt> - String of content
      # * <tt>:encoding</tt> - String containing encoding<tt>utf-8</tt> or <tt>base64</tt>
      # = Examples
      #  @github = Github.new
      #  @github.git_data.create_blob 'user-name', 'repo-name',
      #    "content" => "Content of the blob",
      #    "encoding" => "utf-8"
      #
      def create_blob(user_name, repo_name, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys(params)
        _filter_params_keys(VALID_BLOB_PARAM_NAMES, params)

        raise ArgumentError, "Required params are: #{VALID_BLOB_PARAM_NAMES.join(', ')}" unless _validate_inputs(VALID_BLOB_PARAM_NAMES, params)

        post("/repos/#{user}/#{repo}/git/blobs", params)
      end

    end # Blobs
  end # GitData
end # Github
