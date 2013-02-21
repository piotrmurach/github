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

    # Access to PullRequests::Comments API
    def comments(options={}, &block)
      @comments ||= ApiFactory.new('PullRequests::Comments', current_options.merge(options), &block)
    end

    # List pull requests
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.pull_requests.list
    #  github.pull_requests.list { |req| ... }
    #
    #  pulls = Github::PullRequests.new
    #  pulls.pull_requests.list 'user-name', 'repo-name'
    #
    def list(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_REQUEST_PARAM_NAMES
        assert_values VALID_REQUEST_PARAM_VALUES
      end

      response = get_request("/repos/#{user}/#{repo}/pulls", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single pull request
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.get 'user-name', 'repo-name', 'number'
    #
    #  pulls = Github::PullRequests.new
    #  pulls.get 'user-name', 'repo-name', 'number'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :number])

      get_request("/repos/#{user}/#{repo}/pulls/#{number}", arguments.params)
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
    #  github.pull_requests.create 'user-name', 'repo-name',
    #    "issue" => "5",
    #    "head" => "octocat:new-feature",
    #    "base" => "master"
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_REQUEST_PARAM_NAMES
      end

      post_request("/repos/#{user}/#{repo}/pulls", arguments.params)
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
    #  github.pull_requests.update 'user-name', 'repo-name', 'number'
    #    "title" => "Amazing new title",
    #    "body" => "Update body",
    #    "state" => "open",
    #
    def update(*args)
      arguments(args, :required => [:user, :repo, :number]) do
        sift VALID_REQUEST_PARAM_NAMES
        assert_values VALID_REQUEST_PARAM_VALUES
      end

      patch_request("/repos/#{user}/#{repo}/pulls/#{number}", arguments.params)
    end

    # List commits on a pull request
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.commits 'user-name', 'repo-name', 'number'
    #
    def commits(*args)
      arguments(args, :required => [:user, :repo, :number])

      response = get_request("/repos/#{user}/#{repo}/pulls/#{number}/commits",
        arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # List pull requests files
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.files 'user-name', 'repo-name', 'number'
    #
    def files(*args)
      arguments(args, :required => [:user, :repo, :number])

      response = get_request("/repos/#{user}/#{repo}/pulls/#{number}/files",
        arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if pull request has been merged
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.merged? 'user-name', 'repo-name', 'number'
    #
    def merged?(*args)
      arguments(args, :required => [:user, :repo, :number])

      get_request("/repos/#{user}/#{repo}/pulls/#{number}/merge", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Merge a pull request(Merge Button)
    #
    # = Inputs
    #  <tt>:commit_message</tt> - Optional string -
    #                           The message that will be used for the merge commit
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.merge 'user-name', 'repo-name', 'number'
    #
    def merge(*args)
      arguments(args, :required => [:user, :repo, :number]) do
        sift VALID_REQUEST_PARAM_NAMES
      end

      put_request("/repos/#{user}/#{repo}/pulls/#{number}/merge", arguments.params)
    end

  end # PullRequests
end # Github
