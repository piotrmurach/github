# encoding: utf-8

module Github

  # The Status API allows external services to mark commits with a success,
  # failure, error, or pending state, which is then reflected in pull requests
  # involving those commits.
  class Repos::Statuses < API

    VALID_STATUS_PARAM_NAMES = %w[
      state
      target_url
      description
    ].freeze # :nodoc:

    REQUIRED_PARAMS = %w[ state ].freeze # :nodoc:

    # List Statuses for a specific SHA
    #
    # = Examples
    #  github = Github.new
    #  github.repos.statuses.list 'user-name', 'repo-name', 'sha'
    #  github.repos.statuses.list 'user-name', 'repo-name', 'sha' { |status| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo, :sha])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/statuses/#{sha}", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Create a status
    #
    # = Inputs
    # * <tt>:state</tt> - Required string - State of the status - can be one of
    #                                       pending, success, error, or failure.
    # * <tt>:target_url</tt> - Optional string - Target url to associate with this
    #         status. This URL will be linked from the GitHub UI to allow users
    #         to easily see the ‘source’ of the Status.
    # * <tt>:description</tt> - Optional string - Short description of the status
    #
    # = Examples
    #  github = Github.new
    #  github.repos.statuses.create 'user-name', 'repo-name', 'sha',
    #    "state" =>  "success",
    #    "target_url" => "http://ci.example.com/johndoe/my-repo/builds/sha",
    #    "description" => "Successful build #3 from origin/master"
    #
    def create(*args)
      arguments(args, :required => [:user, :repo, :sha]) do
        sift VALID_STATUS_PARAM_NAMES, :recursive => false
        assert_required REQUIRED_PARAMS
      end
      params = arguments.params

      post_request("/repos/#{user}/#{repo}/statuses/#{sha}", params)
    end

  end # Repos::Statuses
end # Github
