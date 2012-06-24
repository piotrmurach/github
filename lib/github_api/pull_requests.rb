# encoding: utf-8

module Github
  class PullRequests < API
    extend AutoloadHelper

    autoload_all 'github_api/pull_requests',
      :Comments => 'comments'

    VALID_REQUEST_PARAM_NAMES = %w[
      title
      body
      base
      head
      state
      issue
      commit_message
      mime_type
      resource
    ].freeze

    VALID_REQUEST_PARAM_VALUES = {
      'state' => %w[ open closed ]
    }

    # Creates new Gists API
    def initialize(options = {})
      super(options)
    end

    # Access to PullRequests::Comments API
    def comments
      @comments ||= ApiFactory.new 'PullRequests::Comments'
    end

    # List pull requests
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.pull_requests.list
    #  github.pull_requests.list { |req| ... }
    #
    #  pull_reqs = Github::PullRequests.new
    #  pull_reqs.pull_requests.list 'user-name', 'repo-name'
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless (user? && repo?)

      normalize! params
      filter! VALID_REQUEST_PARAM_NAMES, params
      # _merge_mime_type(:pull_request, params)
      assert_valid_values(VALID_REQUEST_PARAM_VALUES, params)

      response = get_request("/repos/#{user}/#{repo}/pulls", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single pull request
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.get 'user-name', 'repo-name', 'request-id'
    #
    #  @pull_reqs = Github::PullRequests.new
    #  @pull_reqs.get 'user-name', 'repo-name', 'request-id'
    #
    def get(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_request, params)

      get_request("/repos/#{user}/#{repo}/pulls/#{request_id}", params)
    end
    alias :find :get

    # Create a pull request
    #
    # = Inputs
    # * <tt>:title</tt> - Required string
    # * <tt>:body</tt> - Optional string
    # * <tt>:base</tt> - Required string - The branch you want your changes pulled into.
    # * <tt>:head</tt> - Required string - The branch where your changes are implemented.
    # note: head and base can be either a sha or a branch name.
    # Typically you would namespace head with a user like this: username:branch.
    # = Alternative Input
    # You can also create a Pull Request from an existing Issue by passing
    # an Issue number instead of <tt>title</tt> and <tt>body</tt>.
    # * <tt>issue</tt> - Required number - Issue number in this repository to turn into a Pull Request.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.pull_requests.create 'user-name', 'repo-name',
    #    "title" => "Amazing new feature",
    #    "body" => "Please pull this in!",
    #    "head" => "octocat:new-feature",
    #    "base" => "master"
    #
    # alternatively
    #
    #  @github.pull_requests.create 'user-name', 'repo-name',
    #    "issue" => "5",
    #    "head" => "octocat:new-feature",
    #    "base" => "master"
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      normalize! params
      # _merge_mime_type(:pull_request, params)
      filter! VALID_REQUEST_PARAM_NAMES, params

      post_request("/repos/#{user}/#{repo}/pulls", params)
    end

    # Update a pull request
    #
    # = Inputs
    # * <tt>:title</tt> - Optional string
    # * <tt>:body</tt> - Optional string
    # * <tt>:state</tt> - Optional string - State of this Pull Request. Valid values are <tt>open</tt> and <tt>closed</tt>.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.pull_requests.update 'user-name', 'repo-name', 'request-id'
    #    "title" => "Amazing new title",
    #    "body" => "Update body",
    #    "state" => "open",
    #
    def update(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      filter! VALID_REQUEST_PARAM_NAMES, params
      # _merge_mime_type(:pull_request, params)
      assert_valid_values(VALID_REQUEST_PARAM_VALUES, params)

      patch_request("/repos/#{user}/#{repo}/pulls/#{request_id}", params)
    end

    # List commits on a pull request
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.commits 'user-name', 'repo-name', 'request-id'
    #
    def commits(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_request, params)

      response = get_request("/repos/#{user}/#{repo}/pulls/#{request_id}/commits", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # List pull requests files
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.files 'user-name', 'repo-name', 'request-id'
    #
    def files(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_request, params)

      response = get_request("/repos/#{user}/#{repo}/pulls/#{request_id}/files", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if pull request has been merged
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.merged? 'user-name', 'repo-name', 'request-id'
    #
    def merged?(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_request, params)

      get_request("/repos/#{user}/#{repo}/pulls/#{request_id}/merge", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Merge a pull request(Merge Button)
    #
    # = Inputs
    #  <tt>:commit_message</tt> - Optional string - The message that will be used for the merge commit
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.merge 'user-name', 'repo-name', 'request-id'
    #
    def merge(user_name, repo_name, request_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of request_id

      normalize! params
      # _merge_mime_type(:pull_request, params)
      filter! VALID_REQUEST_PARAM_NAMES, params

      put_request("/repos/#{user}/#{repo}/pulls/#{request_id}/merge", params)
    end

  end # PullRequests
end # Github
