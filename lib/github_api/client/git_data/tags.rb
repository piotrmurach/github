# encoding: utf-8

module Github
  class Client::GitData::Tags < API
    # This tags api only deals with tag objects -
    # so only annotated tags, not lightweight tags.
    # Refer https://developer.github.com/v3/git/tags/#parameters

    VALID_TAG_PARAM_NAMES = %w[
      tag
      message
      object
      type
      name
      email
      date
      tagger
    ].freeze

    VALID_TAG_PARAM_VALUES = {
      'type' => %w[ blob tree commit ]
    }

    # Get a tag
    #
    # @example
    #  github = Github.new
    #  github.git_data.tags.get 'user-name', 'repo-name', 'sha'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :sha])
      params = arguments.params

      get_request("/repos/#{arguments.user}/#{arguments.repo}/git/tags/#{arguments.sha}", params)
    end
    alias :find :get

    # Create a tag object
    #
    # Note that creating a tag object does not create the reference that
    # makes a tag in Git. If you want to create an annotated tag in Git,
    # you have to do this call to create the tag object, and then create
    # the refs/tags/[tag] reference. If you want to create a lightweight
    # tag, you simply have to create the reference -
    # this call would be unnecessary.
    #
    # @param [Hash] params
    # @input params [String] :tag
    #   The tag
    # @input params [String] :message
    #   The tag message
    # @input params [String] :object
    #   The SHA of the git object this is tagging
    # @input params [String] :type
    #   The type of the object we're tagging.
    #   Normally this is a commit but it can also be a tree or a blob
    # @input params [Hash] :tagger
    #   A hash with information about the individual creating the tag.
    #
    # The tagger hash contains the following keys:
    # @input tagger [String] :name
    #   The name of the author of the tag
    # @input tagger [String] :email
    #   The email of the author of the tag
    # @input tagger [String] :date
    #   When this object was tagged. This is a timestamp in ISO 8601
    #   format: YYYY-MM-DDTHH:MM:SSZ.
    #
    # @xample
    #  github = Github.new
    #  github.git_data.tags.create 'user-name', 'repo-name',
    #     tag: "v0.0.1",
    #     message: "initial version\n",
    #     type: "commit",
    #     object: "c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c",
    #     tagger: {
    #       name: "Scott Chacon",
    #       email: "schacon@gmail.com",
    #       date: "2011-06-17T14:53:3"
    #     }
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_TAG_PARAM_NAMES
        assert_values VALID_TAG_PARAM_VALUES
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/git/tags", arguments.params)
    end
  end # GitData::Tags
end # Github
