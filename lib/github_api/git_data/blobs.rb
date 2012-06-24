# encoding: utf-8

module Github
  class GitData::Blobs < API
    # Since blobs can be any arbitrary binary data, the input and responses for
    # the blob api takes an encoding parameter that can be either utf-8 or base64.
    # If your data cannot be losslessly sent as a UTF-8 string, you can base64 encode it.

    VALID_BLOB_PARAM_NAMES = %w[ content encoding ].freeze

    # Creates new GitData::Blobs API
    def initialize(options = {})
      super(options)
    end

    # Get a blob
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.blobs.get 'user-name', 'repo-name', 'sha'
    #
    def get(user_name, repo_name, sha, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of sha
      normalize! params

      get_request("/repos/#{user}/#{repo}/git/blobs/#{sha}", params)
    end
    alias :find :get

    # Create a blob
    #
    # = Inputs
    # * <tt>:content</tt> - String of content
    # * <tt>:encoding</tt> - String containing encoding<tt>utf-8</tt> or <tt>base64</tt>
    # = Examples
    #  github = Github.new
    #  github.git_data.blobs.create 'user-name', 'repo-name',
    #    "content" => "Content of the blob",
    #    "encoding" => "utf-8"
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      normalize! params
      filter! VALID_BLOB_PARAM_NAMES, params
      assert_required_keys(VALID_BLOB_PARAM_NAMES, params)

      post_request("/repos/#{user}/#{repo}/git/blobs", params)
    end

  end # GitData::Blobs
end # Github
