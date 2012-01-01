# encoding: utf-8

module Github
  class Issues
    module Labels

      VALID_LABEL_INPUTS = %w[ name color ].freeze

      # List all labels for a repository
      #
      # = Examples
      #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
      #  @github.issues.labels
      #  @github.issues.labels { |label| ... }
      #
      def labels(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/labels", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_labels :labels

      # Get a single label
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.label 'user-name', 'repo-name', 'label-id'
      #
      def label(user_name, repo_name, label_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of label_id
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/labels/#{label_id}", params)
      end
      alias :get_label :label

      # Create a label
      #
      # = Inputs
      #  <tt>:name</tt> - Required string
      #  <tt>:color</tt> - Required string - 6 character hex code, without leading #
      #
      # = Examples
      #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
      #  @github.issues.create_label :name => 'API', :color => 'FFFFFF'
      #
      def create_label(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys(params)
        _filter_params_keys(VALID_LABEL_INPUTS, params)

        raise ArgumentError, "Required params are: :name, :color" unless _validate_inputs(VALID_LABEL_INPUTS, params)

        post("/repos/#{user}/#{repo}/labels", params)
      end

      # Update a label
      #
      # = Inputs
      #  <tt>:name</tt> - Required string
      #  <tt>:color</tt> - Required string - 6 character hex code, without leading #
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.update_label 'user-name', 'repo-name', 'label-id', :name => 'API', :color => "FFFFFF"
      #
      def update_label(user_name, repo_name, label_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of label_id

        _normalize_params_keys(params)
        _filter_params_keys(VALID_LABEL_INPUTS, params)

        raise ArgumentError, "Required params are: :name, :color" unless _validate_inputs(VALID_LABEL_INPUTS, params)

        patch("/repos/#{user}/#{repo}/labels/#{label_id}", params)
      end

      # Delete a label
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.delete_label 'user-name', 'repo-name', 'label-id'
      #
      def delete_label(user_name, repo_name, label_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _validate_presence_of label_id
        _normalize_params_keys params

        delete("/repos/#{user}/#{repo}/labels/#{label_id}", params)
      end

      # List labels on an issue
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.labels_for 'user-name', 'repo-name', 'issue-id'
      #
      def labels_for(user_name, repo_name, issue_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of(issue_id)
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
      end
      alias :issue_labels :labels_for

      # Add labels to an issue
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.add_labels 'user-name', 'repo-name', 'issue-id', 'label1', 'label2', ...
      #
      def add_labels(user_name, repo_name, issue_id, *args)
        params = args.last.is_a?(Hash) ? args.pop : {}
        params['data'] = args unless args.empty?

        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of(issue_id)
        _normalize_params_keys(params)

        post("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
      end
      alias :add_issue_labels :add_labels

      # Remove a label from an issue
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.remove_label 'user-name', 'repo-name', 'issue-id', 'label-id'
      #
      # Remove all labels from an issue
      # = Examples
      #  @github = Github.new
      #  @github.issues.remove_label 'user-name', 'repo-name', 'issue-id'
      #
      def remove_label(user_name, repo_name, issue_id, label_id=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of issue_id
        _normalize_params_keys params

        if label_id
          delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels/#{label_id}", params)
        else
          delete("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
        end
      end
      alias :remove_label_from_issue :remove_label

      # Replace all labels for an issue 
      #
      # Sending an empty array ([]) will remove all Labels from the Issue.
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.replace_labels 'user-name', 'repo-name', 'issue-id', 'label1', 'label2', ...
      #
      def replace_labels(user_name, repo_name, issue_id, *args)
        params = args.last.is_a?(Hash) ? args.pop : {}
        params['data'] = [args].flatten unless args.nil?
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of(issue_id)
        _normalize_params_keys(params)

        put("/repos/#{user}/#{repo}/issues/#{issue_id}/labels", params)
      end

      # Get labels for every issue in a milestone
      #
      # = Examples
      #  @github = Github.new
      #  @github.issues.get_label 'user-name', 'repo-name', 'milestone-id'
      #
      def milestone_labels(user_name, repo_name, milestone_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of milestone_id

        response = get("/repos/#{user}/#{repo}/milestones/#{milestone_id}/labels", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :milestone_issues_labels :milestone_labels
      alias :list_milestone_labels :milestone_labels

    end # Labels
  end # Issues
end # Github
