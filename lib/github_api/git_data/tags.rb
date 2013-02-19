# encoding: utf-8

module Github
  class GitData::Tags < API
    # This tags api only deals with tag objects -
    # so only annotated tags, not lightweight tags.

    VALID_TAG_PARAM_NAMES = %w[
      tag
      message
      object
      type
      name
      email
      date
      sha
      url
      tagger
    ].freeze

    VALID_TAG_PARAM_VALUES = {
      'type' => %w[ blob tree commit ]
    }

    # Get a tag
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.tags.get 'user-name', 'repo-name', 'sha'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :sha])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/git/tags/#{sha}", params)
    end
    alias :find :get

    # Create a tag object
    # Note that creating a tag object does not create the reference that
    # makes a tag in Git. If you want to create an annotated tag in Git,
    # you have to do this call to create the tag object, and then create
    # the <tt>refs/tags/[tag]</tt> reference. If you want to create a lightweight tag, you simply have to create the reference - this call would be unnecessary.
    #
    # = Parameters
    # * <tt>:tag</tt> - String of the tag
    # * <tt>:message</tt> - String of the tag message
    # * <tt>:object</tt> - String of the SHA of the git object this is tagging
    # * <tt>:type</tt> - String of the type of the object we're tagging. Normally this is a <tt>commit</tt> but it can also be a <tt>tree</tt> or a <tt>blob</tt>
    # * tagger.name:: String of the name of the author of the tag
    # * tagger.email:: String of the email of the author of the tag
    # * tagger.date:: Timestamp of when this object was tagged
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.tags.create 'user-name', 'repo-name',
    #    "tag" => "v0.0.1",
    #    "message" => "initial version\n",
    #    "type" => "commit",
    #    "object" => "c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c",
    #    "tagger" => {
    #      "name" => "Scott Chacon",
    #      "email" => "schacon@gmail.com",
    #      "date" => "2011-06-17T14:53:3"
    #    }
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_TAG_PARAM_NAMES
        assert_values VALID_TAG_PARAM_VALUES
      end
      params = arguments.params

      post_request("/repos/#{user}/#{repo}/git/tags", params)
    end

  end # GitData::Tags
end # Github
