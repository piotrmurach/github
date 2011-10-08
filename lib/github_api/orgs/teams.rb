# encoding: utf-8

module Github
  class Orgs
    # All actions against teams require at a minimum an authenticated user
    # who is a member of the owner’s team in the :org being managed.
    # Api calls that require explicit permissions are noted.
    module Teams

      VALID_TEAM_PARAM_NAMES = %w[ name repo_names permission ]
      VALID_TEAM_PARAM_VALUES = {
        'permission' => %w[ pull push admin ]
      }

      # List teams
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.teams 'org-name'
      #
      def teams(org_name, params={})
        _validate_presence_of org_name
        _normalize_params_keys(params)

        get("/orgs/#{org_name}/teams", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Get a team
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.team 'team-name'
      #
      def team(team_name, params={})
        _validate_presence_of team_name
        _normalize_params_keys(params)

        get("/teams/#{team_name}", params)
      end

      # Create a team
      #
      # In order to create a team, the authenticated user must be an owner of<tt>:org</tt>.
      # = Inputs
      #  <tt>:name</tt> - Required string
      #  <tt>:repo_names</tt> - Optional array of strings
      #  <tt>:permission</tt> - Optional string
      #    * <tt>pull</tt> - team members can pull, but not push or administor this repositories. Default
      #    * <tt>push</tt> - team members can pull and push, but not administor this repositores.
      #    * <tt>admin</tt> - team members can pull, push and administor these repositories.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.create_team 'org-name',
      #    "name" => "new team",
      #    "permission" => "push",
      #    "repo_names" => [
      #      "github/dotfiles"
      #     ]
      #
      def create_team(org_name, params={})
        _validate_presence_of org_name
        _normalize_params_keys(params)
        _filter_params_keys(VALID_TEAM_PARAM_NAMES, params)
        _validate_params_values(VALID_TEAM_PARAM_VALUES, params)

        raise ArgumentError, "Required params are: :name" unless _validate_inputs(%w[ name ], params)

        post("/orgs/#{org_name}/teams", params)
      end

      # Create a team
      # In order to edit a team, the authenticated user must be an owner of the org that the team is associated with.
      #
      # = Inputs
      #  <tt>:name</tt> - Required string
      #  <tt>:permission</tt> - Optional string
      #    * <tt>pull</tt> - team members can pull, but not push or administor this repositories. Default
      #    * <tt>push</tt> - team members can pull and push, but not administor this repositores.
      #    * <tt>admin</tt> - team members can pull, push and administor these repositories.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.edit_team 'team-name',
      #    "name" => "new team name",
      #    "permission" => "push"
      #
      def edit_team(team_name, params={})
        _validate_presence_of team_name
        _normalize_params_keys(params)
        _filter_params_keys(VALID_TEAM_PARAM_NAMES, params)
        _validate_params_values(VALID_TEAM_PARAM_VALUES, params)

        raise ArgumentError, "Required params are: :name" unless _validate_inputs(%w[ name ], params)

        patch("/teams/#{team_name}", params)
      end

      # Delete a team
      # In order to delete a team, the authenticated user must be an owner of the org that the team is associated with
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.delete_team 'team-name'
      #
      def delete_team(team_name, params={})
        _validate_presence_of team_name
        _normalize_params_keys(params)
        delete("/teams/#{team_name}", params)
      end

      # List team members
      # In order to list members in a team, the authenticated user must be a member of the team.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.team_members 'team-name'
      #  @github.orgs.team_members 'team-name' { |member| ... }
      #
      def team_members(team_name, params={})
        _validate_presence_of team_name
        _normalize_params_keys(params)

        response = get("/teams/:id/members", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Check if a user is a member of a team
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.team_member? 'team-name', 'user-name'
      #
      def team_member?(team_name, member_name, params={})
        _validate_presence_of team_name, member_name
        _normalize_params_keys(params)
        get("/teams/#{team_name}/members/#{member_name}", params)
        true
      rescue Github::ResourceNotFound
        false
      end

      # Add a team member
      # In order to add a user to a team, the authenticated user must have ‘admin’ permissions to the team or be an owner of the org that the team is associated with.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.add_team_member 'team-name', 'user-name'
      #
      def add_team_member(team_name, member_name, params={})
        _validate_presence_of team_name, member_name
        _normalize_params_keys(params)
        put("/teams/#{team_name}/members/#{member_name}", params)
      end

      # Remove a team member
      # In order to remove a user from a team, the authenticated user must
      # have ‘admin’ permissions to the team or be an owner of the org that
      # the team is associated with.
      # note: This does not delete the user, it just remove them from the team.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.remove_team_member 'team-name', 'member-name'
      #
      def remove_team_member(team_name, member_name, params={})
        _validate_presence_of team_name, member_name
        _normalize_params_keys(params)
        delete("/teams/#{team_name}/members/#{member_name}", params)
      end

      # List team repositories
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.team_repos 'team-name'
      #
      def team_repos(team_name, params={})
        _validate_presence_of team_name, member_name
        _normalize_params_keys(params)

        response = get("/teams/#{team_name}/repos", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Check if a repository belongs to a team
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.team_repo? 'team-name'
      #
      def team_repo?(team_name, user_name, repo_name, params={})
        _validate_presence_of team_name, user_name, repo_name
        _normalize_params_keys(params)
        get("/teams/#{team_name}/repos/#{user_name}/#{repo_name}", params)
        true
      rescue Github::ResourceNotFound
        false
      end

      # Add a team repository
      # In order to add a repo to a team, the authenticated user must be
      # an owner of the org that the team is associated with.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.add_team_repo 'team-name', 'user-name', 'repo-name'
      #
      def add_team_repo(team_name, user_name, repo_name, params={})
        _validate_presence_of team_name, user_name, repo_name
        _normalize_params_keys(params)
        put("/teams/#{team_name}/repos/#{user_name}/#{repo_name}", params)
      end

      # Remove a team repository
      # In order to add a repo to a team, the authenticated user must be
      # an owner of the org that the team is associated with. 
      # note: This does not delete the repo, it just removes it from the team.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.remove_team_repo 'team-name', 'user-name', 'repo-name'
      #
      def remove_team_repo(team_name, user_name, repo_name, params={})
        _validate_presence_of team_name, user_name, repo_name
        _normalize_params_keys(params)
        delete("/teams/#{team_name}/repos/#{user_name}/#{repo_name}", params)
      end

    end # Teams
  end # Orgs
end # Github
