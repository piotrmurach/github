# encoding: utf-8

module Github
  class Issues::Labels < API

    VALID_LABEL_INPUTS = %w[ name color ].freeze

    # Creates new Issues::Labels API
    def initialize(options = {})
      super(options)
    end

    # List all labels for a repository
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.issues.labels.list
    #  github.issues.labels.list { |label| ... }
    #
    def list(user_name, repo_name, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/labels", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single label
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.find 'user-name', 'repo-name', 'label-id'
    #
    def get(user_name, repo_name, label_id, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, label_id
      normalize! params

      get_request("/repos/#{user}/#{repo}/labels/#{label_id}", params)
    end
    alias :find :get

    # Create a label
    #
    # = Inputs
    #  <tt>:name</tt> - Required string
    #  <tt>:color</tt> - Required string - 6 character hex code, without leading #
    #
    # = Examples
    #  github = Github.new :user => 'user-name', :repo => 'repo-name'
    #  github.issues.labels.create :name => 'API', :color => 'FFFFFF'
    #
    def create(user_name, repo_name, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo

      normalize! params
      filter! VALID_LABEL_INPUTS, params
      assert_required_keys(VALID_LABEL_INPUTS, params)

      post_request("/repos/#{user}/#{repo}/labels", params)
    end

    # Update a label
    #
    # = Inputs
    #  <tt>:name</tt> - Required string
    #  <tt>:color</tt> - Required string-6 character hex code, without leading #
    #
    # = Examples
    #  @github = Github.new
    #  @github.issues.labels.update 'user-name', 'repo-name', 'label-id',
    #    :name => 'API', :color => "FFFFFF"
    #
    def update(user_name, repo_name, label_id, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, label_id

      normalize! params
      filter! VALID_LABEL_INPUTS, params
      assert_required_keys(VALID_LABEL_INPUTS, params)

      patch_request("/repos/#{user}/#{repo}/labels/#{label_id}", params)
    end
    alias :edit :update

    # Delete a label
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.delete 'user-name', 'repo-name', 'label-id'
    #
    def delete(user_name, repo_name, label_id, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo

      assert_presence_of label_id
      normalize! params

      delete_request("/repos/#{user}/#{repo}/labels/#{label_id}", params)
    end

    # List labels on an issue
    #
    # = Examples
    #  @github = Github.new
    #  @github.issues.labels.issue 'user-name', 'repo-name', 'issue-id'
    #
    def issue(user_name, repo_name, issue_id, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, issue_id
      normalize! params

      get_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
    end

    # Add labels to an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.add 'user-name', 'repo-name', 'issue-id', 'label1', 'label2', ...
    #
    def add(user_name, repo_name, issue_id, *args)
      params = args.extract_options!
      params['data'] = args unless args.empty?

      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, issue_id
      normalize! params

      post_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
    end
    alias :<< :add

    # Remove a label from an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.remove 'user-name', 'repo-name', 'issue-id', 'label-id'
    #
    # Remove all labels from an issue
    # = Examples
    #  github = Github.new
    #  github.issues.labels.remove 'user-name', 'repo-name', 'issue-id'
    #
    def remove(user_name, repo_name, issue_id, label_id=nil, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, issue_id
      normalize! params

      if label_id
        delete_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}", params)
      else
        delete_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
      end
    end

    # Replace all labels for an issue 
    #
    # Sending an empty array ([]) will remove all Labels from the Issue.
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.replace 'user-name', 'repo-name', 'issue-id', 'label1', 'label2', ...
    #
    def replace(user_name, repo_name, issue_id, *args)
      params = args.extract_options!
      params['data'] = args unless args.empty?

      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, issue_id
      normalize! params

      put_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
    end

    # Get labels for every issue in a milestone
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels. 'user-name', 'repo-name', 'milestone-id'
    #
    def milestone(user_name, repo_name, milestone_id, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, milestone_id
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

  end # Issues::Labels
end # Github
