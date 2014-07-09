# encoding: utf-8

module Github

  # Since blobs can be any arbitrary binary data, the input and responses for
  # the blob api takes an encoding parameter that can be either utf-8 or base64.
  # If your data cannot be losslessly sent as a UTF-8 string, you can base64 encode it.
  class Client::GitData::Blobs < API

    VALID_BLOB_PARAM_NAMES = %w[ content encoding ].freeze

    # Get a blob
    #
    # @example
    #  github = Github.new
    #  github.git_data.blobs.get 'user-name', 'repo-name', 'sha'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :sha])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/git/blobs/#{arguments.sha}", arguments.params)
    end
    alias :find :get

    # Create a blob
    #
    # @param [Hash] params
    # @input params [String] :content
    #   String of content.
    # @input params [String] :encoding
    #   String containing encoding<tt>utf-8</tt> or <tt>base64</tt>
    #
    # @examples
    #  github = Github.new
    #  github.git_data.blobs.create 'user-name', 'repo-name',
    #    content: "Content of the blob",
    #    encoding: "utf-8"
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_BLOB_PARAM_NAMES
        assert_required VALID_BLOB_PARAM_NAMES
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/git/blobs", arguments.params)
    end
  end # GitData::Blobs
end # Github
