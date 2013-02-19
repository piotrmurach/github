# encoding: utf-8

module Github
  class Issues::Labels < API

    VALID_LABEL_INPUTS = %w[ name color ].freeze

    # List all labels for a repository
    #
    # = Examples
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.labels.list
    #  github.issues.labels.list { |label| ... }
    #
    # Get labels for every issue in a milestone
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.list 'user-name', 'repo-name', milestone_id: 'milestone-id'
    #
    # List labels on an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.list 'user-name', 'repo-name', issue_id: 'issue-id'
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = if (milestone_id = params.delete('milestone_id'))
        get_request("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels", params)
      elsif (issue_id = params.delete('issue_id'))
        get_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
      else
        get_request("/repos/#{user}/#{repo}/labels", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single label
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.find 'user-name', 'repo-name', 'label-name'
    #
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.labels.get label_name: 'bug'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :label_name])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/labels/#{label_name}", params)
    end
    alias :find :get

    # Create a label
    #
    # = Inputs
    #  <tt>:name</tt> - Required string
    #  <tt>:color</tt> - Required string - 6 character hex code, without leading #
    #
    # = Examples
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.labels.create name: 'API', color: 'FFFFFF'
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_LABEL_INPUTS
        assert_required VALID_LABEL_INPUTS
      end

      post_request("/repos/#{user}/#{repo}/labels", arguments.params)
    end

    # Update a label
    #
    # = Inputs
    #  <tt>:name</tt> - Required string
    #  <tt>:color</tt> - Required string-6 character hex code, without leading #
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.update 'user-name', 'repo-name', 'label-name',
    #    name: 'API', color: "FFFFFF"
    #
    def update(*args)
      arguments(args, :required => [:user, :repo, :label_name]) do
        sift VALID_LABEL_INPUTS
        assert_required VALID_LABEL_INPUTS
      end

      patch_request("/repos/#{user}/#{repo}/labels/#{label_name}", arguments.params)
    end
    alias :edit :update

    # Delete a label
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.delete 'user-name', 'repo-name', 'label-name'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :label_name])

      delete_request("/repos/#{user}/#{repo}/labels/#{label_name}", arguments.params)
    end

    # Add labels to an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.add 'user-name', 'repo-name', 'issue-id', 'label1', 'label2', ...
    #
    def add(*args)
      arguments(args, :required => [:user, :repo, :issue_id])
      params = arguments.params
      params['data'] = arguments.remaining unless arguments.remaining.empty?

      post_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
    end
    alias :<< :add

    # Remove a label from an issue
    #
    # = Examples
    #  github = Github.new
    #  github.issues.labels.remove 'user-name', 'repo-name', 'issue-id',
    #    lable_name: 'label-name'
    #
    # Remove all labels from an issue
    # = Examples
    #  github = Github.new
    #  github.issues.labels.remove 'user-name', 'repo-name', 'issue-id'
    #
    def remove(*args)
      arguments(args, :required => [:user, :repo, :issue_id])
      params = arguments.params

      if (label_name = params.delete('label_name'))
        delete_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_name}", params)
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
    def replace(*args)
      arguments(args, :required => [:user, :repo, :issue_id])
      params = arguments.params
      params['data'] = arguments.remaining unless arguments.remaining.empty?

      put_request("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
    end

  end # Issues::Labels
end # Github
