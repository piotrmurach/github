# encoding: utf-8

module Github
  class Repos::Statuses < API
    # The Status API allows external services to mark commits with a success,
    # failure, error, or pending state, which is then reflected in pull requests
    # involving those commits.

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
    def list(user_name, repo_name, sha, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

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
    def create(user_name, repo_name, sha, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      normalize! params
      filter! VALID_STATUS_PARAM_NAMES, params, :recursive => false
      assert_required_keys(REQUIRED_PARAMS, params)

      post_request("/repos/#{user}/#{repo}/statuses/#{sha}", params)
    end

  end # Repos::Statuses
end # Github
