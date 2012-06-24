# encoding: utf-8

module Github
  class Orgs::Teams < API
    # All actions against teams require at a minimum an authenticated user
    # who is a member of the owner’s team in the :org being managed.
    # Api calls that require explicit permissions are noted.

    VALID_TEAM_PARAM_NAMES = %w[ name repo_names permission ].freeze
    VALID_TEAM_PARAM_VALUES = {
      'permission' => %w[ pull push admin ].freeze
    }

    # List teams
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.list 'org-name'
    #
    def list(org_name, params={})
      _validate_presence_of org_name
      normalize! params

      response = get_request("/orgs/#{org_name}/teams", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a team
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.get 'team-name'
    #
    def get(team_name, params={})
      _validate_presence_of team_name
      normalize! params

      get_request("/teams/#{team_name}", params)
    end
    alias :find :get

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
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.create 'org-name',
    #    "name" => "new team",
    #    "permission" => "push",
    #    "repo_names" => [
    #      "github/dotfiles"
    #     ]
    #
    def create(org_name, params={})
      _validate_presence_of org_name
      normalize! params
      _filter_params_keys(VALID_TEAM_PARAM_NAMES, params)
      assert_valid_values(VALID_TEAM_PARAM_VALUES, params)
      assert_required_keys(%w[ name ], params)

      post_request("/orgs/#{org_name}/teams", params)
    end

    # Edit a team
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
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.edit 'team-name',
    #    "name" => "new team name",
    #    "permission" => "push"
    #
    def edit(team_name, params={})
      _validate_presence_of team_name
      normalize! params

      _filter_params_keys(VALID_TEAM_PARAM_NAMES, params)
      assert_valid_values(VALID_TEAM_PARAM_VALUES, params)
      assert_required_keys(%w[ name ], params)

      patch_request("/teams/#{team_name}", params)
    end

    # Delete a team
    # In order to delete a team, the authenticated user must be an owner of the org that the team is associated with
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.delete 'team-name'
    #
    def delete(team_name, params={})
      _validate_presence_of team_name
      normalize! params
      delete_request("/teams/#{team_name}", params)
    end
    alias :remove :delete

    # List team members
    # In order to list members in a team, the authenticated user must be a member of the team.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.list_members 'team-name'
    #  github.orgs.teams.list_members 'team-name' { |member| ... }
    #
    def list_members(team_name, params={})
      _validate_presence_of team_name
      normalize! params

      response = get_request("/teams/#{team_name}/members", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all_members :list_members

    # Check if a user is a member of a team
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.team_member? 'team-name', 'user-name'
    #
    def team_member?(team_name, member_name, params={})
      _validate_presence_of team_name, member_name
      normalize! params
      get_request("/teams/#{team_name}/members/#{member_name}", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Add a team member
    # In order to add a user to a team, the authenticated user must have ‘admin’ permissions to the team or be an owner of the org that the team is associated with.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.add_member 'team-name', 'user-name'
    #
    def add_member(team_name, member_name, params={})
      _validate_presence_of team_name, member_name
      normalize! params
      put_request("/teams/#{team_name}/members/#{member_name}", params)
    end
    alias :add_team_member :add_member

    # Remove a team member
    # In order to remove a user from a team, the authenticated user must
    # have ‘admin’ permissions to the team or be an owner of the org that
    # the team is associated with.
    # note: This does not delete the user, it just remove them from the team.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.remove_member 'team-name', 'member-name'
    #
    def remove_member(team_name, member_name, params={})
      _validate_presence_of team_name, member_name
      normalize! params
      delete_request("/teams/#{team_name}/members/#{member_name}", params)
    end
    alias :remove_team_member :remove_member

    # List team repositories
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.list_repos 'team-name'
    #
    def list_repos(team_name, params={})
      _validate_presence_of team_name
      normalize! params

      response = get_request("/teams/#{team_name}/repos", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :repos :list_repos

    # Check if a repository belongs to a team
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.team_repo? 'team-name', 'user-name', 'repo-name'
    #
    def team_repo?(team_name, user_name, repo_name, params={})
      _validate_presence_of team_name, user_name, repo_name
      normalize! params
      get_request("/teams/#{team_name}/repos/#{user_name}/#{repo_name}", params)
      true
    rescue Github::Error::NotFound
      false
    end
    alias :team_repository? :team_repo?

    # Add a team repository
    #
    # In order to add a repo to a team, the authenticated user must be
    # an owner of the org that the team is associated with. Also, the repo
    # must be owned by the organization, or a direct for of a repo owned
    # by the organization.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.add_repo 'team-name', 'user-name', 'repo-name'
    #
    def add_repo(team_name, user_name, repo_name, params={})
      _validate_presence_of team_name, user_name, repo_name
      normalize! params
      put_request("/teams/#{team_name}/repos/#{user_name}/#{repo_name}", params)
    end
    alias :add_repository :add_repo

    # Remove a team repository
    #
    # In order to add a repo to a team, the authenticated user must be
    # an owner of the org that the team is associated with.
    # note: This does not delete the repo, it just removes it from the team.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.teams.remove_repo 'team-name', 'user-name', 'repo-name'
    #
    def remove_repo(team_name, user_name, repo_name, params={})
      _validate_presence_of team_name, user_name, repo_name
      normalize! params
      delete_request("/teams/#{team_name}/repos/#{user_name}/#{repo_name}", params)
    end
    alias :remove_repository :remove_repo

  end # Orgs::Teams
end # Github
