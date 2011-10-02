# encoding: utf-8

module Github
  class Issues
    module Milestones

      VALID_MILSTONE_OPTIONS = {
       'state' => %w[ open closed ],
       'sort'  => %w[ due_date completeness ],
       'direction' => %w[ desc asc ]
      }

      VALID_MILESTONE_INPUTS = %w[ title state description due_on ]

      # List milestones for a repository
      #
      # = Parameters
      # <tt>:state</tt> - <tt>open</tt>, <tt>closed</tt>, default: <tt>open</tt>
      # <tt>:sort</tt> - <tt>due_date</tt>, <tt>completeness</tt>, default: <tt>due_date</tt>
      # <tt>:direction</tt> - <tt>asc</tt>, <tt>desc</tt>, default: <tt>desc</tt>
      #
      # = Examples
      #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
      #  @github.issues.milestones
      #
      def milestones(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys(params)
        _filter_params_keys(VALID_MILSTONE_OPTIONS.keys, params)
        _validate_params_values(VALID_MILSTONE_OPTIONS, params)
        
        response = get("/repos/#{user}/#{repo}/milestones")
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Get a single milestone
      #
      # = Examples
      #  @github = Github.new 
      #  @github.issues.get_milestone 'user-name', 'repo-name', 'milestone-id'
      #
      def get_milestone(user, repo, milestone_id)
        get("/repos/:user/:repo/milestones/:id")
      end

      # Create a milestone
      #
      # = Inputs
      #  <tt>:title</tt> - Required string
      #  <tt>:state</tt> - Optional string - <tt>open</tt> or <tt>closed</tt>
      #  <tt>:description</tt> - Optional string 
      #  <tt>:due_on</tt> - Optional string - ISO 8601 time
      # 
      # = Examples
      #  @github = Github.new :user => 'user-name', :repo => 'repo-name'
      #  @github.issues.create_milestone :title => 'hello-world'
      #
      def create_milestone(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        
        _normalize_params_keys(params)
        _filter_params_keys(VALID_MILESTONE_INPUTS, params)
        
        raise ArgumentError, "Required params are: :title" unless _validate_inputs(%w[ title ], params)

        post("/repos/#{user}/#{repo}/milestones")
      end
      

      # Update a milestone
      #
      # = Inputs
      #  <tt>:title</tt> - Required string
      #  <tt>:state</tt> - Optional string - <tt>open</tt> or <tt>closed</tt>
      #  <tt>:description</tt> - Optional string 
      #  <tt>:due_on</tt> - Optional string - ISO 8601 time
      # 
      # = Examples
      #  @github = Github.new 
      #  @github.issues.update_milestone 'user-name', 'repo-name', 'milestone-id', :title => 'hello-world'
      #
      def update_milestone(user_name, repo_name, milestone_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of milestone_id
        
        _normalize_params_keys(params)
        _filter_params_keys(VALID_MILESTONE_INPUTS, params)
        
        raise ArgumentError, "Required params are: :title" unless _validate_inputs(%w[ title ], params)

        patch("/repos/#{user}/#{repo}/milestones/#{milestone_id}")
      end

      # Delete a milestone
      # 
      # = Examples
      #  @github = Github.new 
      #  @github.issues.delete_milestone 'user-name', 'repo-name', 'milestone-id'
      #
      def delete_milestone(user_name, repo_name, milestone_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of milestone_id
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/milestones/#{milestone_id}")
      end

    end # Milestones
  end # Issues
end # Github
