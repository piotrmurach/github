# encoding: utf-8

module Github
  # All actions against teams require at a minimum an authenticated user
  # who is a member of the owner's team in the :org being managed.
  # Api calls that require explicit permissions are noted.
  class Client::Orgs::Teams < API
    # List user teams
    #
    # List all of the teams across all of the organizations
    # to which the authenticated user belongs. This method
    # requires user or repo scope when authenticating via OAuth.
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.list
    #
    # List teams
    #
    # @see https://developer.github.com/v3/orgs/teams/#list-teams
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.list org: 'org-name'
    #
    # @api public
    def list(*args)
      params = arguments(args).params

      if (org = params.delete('org'))
        response = get_request("/orgs/#{org}/teams", params)
      else
        response = get_request('/user/teams', params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get a team
    #
    # @see https://developer.github.com/v3/orgs/teams/#get-team
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.get 'team-id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:id])

      get_request("/teams/#{arguments.id}", arguments.params)
    end
    alias_method :find, :get

    # Create a team
    #
    # In order to create a team, the authenticated user must be an owner of :org
    #
    # @see https://developer.github.com/v3/orgs/teams/#create-team
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Required. The name of the team
    # @option params [String] :description
    #   The description of the team.
    # @option params [Array[String]] :repo_names
    #   The repositories to add the team to.
    # @option params [String] :privacy
    #   The level of privacy this team should have. Can be one of:
    #     * secret - only visible to organization owners and
    #                members of this team.
    #     * closed - visible to all members of this organization.
    #   Default: secret
    # @option params [String] :permission
    #   The permission to grant the team. Can be one of:
    #    * pull - team members can pull, but not push or
    #             administor this repositories.
    #    * push - team members can pull and push,
    #             but not administor this repositores.
    #    * admin - team members can pull, push and
    #              administor these repositories.
    #   Default: pull
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.create 'org-name',
    #     name: "new team",
    #     permission: "push",
    #     repo_names: [
    #       "github/dotfiles"
    #     ]
    #
    # @api public
    def create(*args)
      arguments(args, required: [:org_name]) do
        assert_required %w(name)
      end

      post_request("/orgs/#{arguments.org_name}/teams", arguments.params)
    end

    # Edit a team
    #
    # In order to edit a team, the authenticated user must be an owner
    # of the org that the team is associated with.
    #
    # @see https://developer.github.com/v3/orgs/teams/#edit-team
    #
    # @param [Hash] params
    # @option params [String] :name
    #   The repositories to add the team to.
    # @option params [String] :description
    #   The description of the team.
    # @option params [String] :privacy
    #   The level of privacy this team should have. Can be one of:
    #     * secret - only visible to organization owners and
    #                members of this team.
    #     * closed - visible to all members of this organization.
    #   Default: secret
    # @option params [String] :permission
    #   The permission to grant the team. Can be one of:
    #    * pull - team members can pull, but not push or
    #             administor this repositories.
    #    * push - team members can pull and push,
    #             but not administor this repositores.
    #    * admin - team members can pull, push and
    #              administor these repositories.
    #   Default: pull
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.edit 'team-id',
    #    name: "new team name",
    #    permission: "push"
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:id]) do
        assert_required %w(name)
      end

      patch_request("/teams/#{arguments.id}", arguments.params)
    end

    # Delete a team
    #
    # @see https://developer.github.com/v3/orgs/teams/#delete-team
    #
    # In order to delete a team, the authenticated user must be an owner
    # of the org that the team is associated with
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.delete 'team-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:id])

      delete_request("/teams/#{arguments.id}", arguments.params)
    end
    alias_method :remove, :delete

    # List team members
    #
    # In order to list members in a team, the authenticated user
    # must be a member of the team.
    #
    # @see https://developer.github.com/v3/orgs/teams/#list-team-members
    #
    # @param [Integer] :team_id
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.list_members 'team-id'
    #   github.orgs.teams.list_members 'team-id' { |member| ... }
    #
    # @api public
    def list_members(*args)
      arguments(args, required: [:team_id])

      response = get_request("/teams/#{arguments.team_id}/members", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all_members, :list_members

    # Check if a user is a member of a team
    #
    # @see https://developer.github.com/v3/orgs/teams/#get-team-member
    #
    # @param [Integer] :team_id
    # @param [String] :username
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.team_member? 'team-id', 'user-name'
    #
    # @api public
    def team_member?(*args)
      arguments(args, required: [:team_id, :user])

      response = get_request("/teams/#{arguments.team_id}/members/#{arguments.user}", arguments.params)
      response.status == 204
    rescue Github::Error::NotFound
      false
    end

    # Add a team member
    #
    # In order to add a user to a team, the authenticated user must
    # have 'admin' permissions to the team or be an owner of the org
    # that the team is associated with.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.add_member 'team-id', 'user-name'
    #
    # @api public
    def add_member(*args)
      arguments(args, required: [:id, :user])

      put_request("/teams/#{arguments.id}/members/#{arguments.user}",
                  arguments.params)
    end
    alias_method :add_team_member, :add_member

    # Remove a team member
    #
    # @see https://developer.github.com/v3/orgs/teams/#remove-team-member
    #
    # In order to remove a user from a team, the authenticated user must
    # have 'admin' permissions to the team or be an owner of the org that
    # the team is associated with.
    # note: This does not delete the user, it just remove them from the team.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.remove_member 'team-id', 'user-name'
    #
    # @api public
    def remove_member(*args)
      arguments(args, required: [:id, :user])

      delete_request("/teams/#{arguments.id}/members/#{arguments.user}",
                     arguments.params)
    end
    alias_method :remove_team_member, :remove_member

    # Get team membership
    #
    # In order to get a user's membership with a team,
    # the team must be visible to the authenticated user.
    #
    # @see https://developer.github.com/v3/orgs/teams/#get-team-membership
    #
    # @param [Integer] :team_id
    # @param [String]  :username
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.team_membership 'team-id', 'username'
    #
    # @api public
    def team_membership(*args)
      arguments(args, required: [:team_id, :username])

      get_request("/teams/#{arguments.team_id}/memberships/#{arguments.username}",
                  arguments.params)
    end

    # Add a team membership
    #
    # In order to add a user to a team, the authenticated user must
    # have 'admin' permissions to the team or be an owner of the org
    # that the team is associated with.
    #
    # @see https://developer.github.com/v3/orgs/teams/#add-team-membership
    #
    # @param [Integer] :team_id
    # @param [String] :username
    # @param [Hash] :params
    # @option params [String] :role
    #   The role that this user should have in the team. Can be one of:
    #     * member - a normal member of the team.
    #     * maintainer - a team maintainer. Able to add/remove
    #       other team members, promote other team members to
    #       team maintainer, and edit the team's name and description.
    #   Default: member
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.add_membership 'team-id', 'user-name'
    #
    # @api public
    def add_membership(*args)
      arguments(args, required: [:team_id, :user])

      put_request("/teams/#{arguments.team_id}/memberships/#{arguments.user}",
                  arguments.params)
    end
    alias_method :add_team_membership, :add_membership

    # Remove a team membership
    #
    # In order to remove a user from a team, the authenticated user must
    # have 'admin' permissions to the team or be an owner of the org that
    # the team is associated with.
    # note: This does not delete the user, it just remove them from the team.
    #
    # @see https://developer.github.com/v3/orgs/teams/#remove-team-membership
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.remove_membership 'team-id', 'user-name'
    #
    # @api public
    def remove_membership(*args)
      arguments(args, required: [:team_id, :user])

      delete_request("/teams/#{arguments.team_id}/memberships/#{arguments.user}",
                     arguments.params)
    end
    alias_method :remove_team_membership, :remove_membership

    # List team repositories
    #
    # @see https://developer.github.com/v3/orgs/teams/#list-team-repos
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.list_repos 'team-id'
    #
    # @api public
    def list_repos(*args)
      arguments(args, required: [:id])

      response = get_request("/teams/#{arguments.id}/repos", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :repos, :list_repos

    # Check if a repository belongs to a team
    #
    # @see https://developer.github.com/v3/orgs/teams/#get-team-repo
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.team_repo? 'team-id', 'user-name', 'repo-name'
    #
    # @api public
    def team_repo?(*args)
      arguments(args, required: [:id, :user, :repo])

      response = get_request("/teams/#{arguments.id}/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
      response.status == 204
    rescue Github::Error::NotFound
      false
    end
    alias_method :team_repository?, :team_repo?

    # Add a team repository
    #
    # In order to add a repo to a team, the authenticated user must be
    # an owner of the org that the team is associated with. Also, the repo
    # must be owned by the organization, or a direct for of a repo owned
    # by the organization.
    #
    # @see https://developer.github.com/v3/orgs/teams/#add-team-repo
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.add_repo 'team-id', 'user-name', 'repo-name'
    #
    # @api public
    def add_repo(*args)
      arguments(args, required: [:id, :user, :repo])

      put_request("/teams/#{arguments.id}/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
    alias_method :add_repository, :add_repo

    # Remove a team repository
    #
    # In order to add a repo to a team, the authenticated user must be
    # an owner of the org that the team is associated with.
    # note: This does not delete the repo, it just removes it from the team.
    #
    # @see https://developer.github.com/v3/orgs/teams/#remove-team-repo
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.remove_repo 'team-id', 'user-name', 'repo-name'
    #
    # @api public
    def remove_repo(*args)
      arguments(args, required: [:id, :user, :repo])

      delete_request("/teams/#{arguments.id}/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
    alias_method :remove_repository, :remove_repo
  end # Client::Orgs::Teams
end # Github
