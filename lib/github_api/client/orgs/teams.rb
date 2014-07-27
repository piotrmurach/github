# encoding: utf-8

module Github
  class Client::Orgs::Teams < API
    # All actions against teams require at a minimum an authenticated user
    # who is a member of the owner’s team in the :org being managed.
    # Api calls that require explicit permissions are noted.

    VALID_TEAM_PARAM_NAMES = %w[ name repo_names permission ].freeze
    VALID_TEAM_PARAM_VALUES = {
      'permission' => %w[ pull push admin ].freeze
    }

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
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.list org: 'org-name'
    #
    # @api public
    def list(*args)
      params = arguments(args).params

      response = if org = params.delete('org')
        get_request("/orgs/#{org}/teams", params)
      else
        get_request("/user/teams", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a team
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
    alias :find :get

    # Create a team
    #
    # In order to create a team, the authenticated user must be an owner of :org
    #
    # @param [Hash] params
    # @input params [String] :name
    #   Required. The name of the team
    # @input params [Array[String]] :repo_names
    #   The repositories to add the team to.
    # @input params [String] :permission
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
        permit VALID_TEAM_PARAM_NAMES
        assert_values VALID_TEAM_PARAM_VALUES
        assert_required %w[name]
      end

      post_request("/orgs/#{arguments.org_name}/teams", arguments.params)
    end

    # Edit a team
    #
    # In order to edit a team, the authenticated user must be an owner
    # of the org that the team is associated with.
    #
    # @param [Hash] params
    # @input params [String] :name
    #   The repositories to add the team to.
    # @input params [String] :permission
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
        permit VALID_TEAM_PARAM_NAMES
        assert_values VALID_TEAM_PARAM_VALUES
        assert_required %w[name]
      end

      patch_request("/teams/#{arguments.id}", arguments.params)
    end

    # Delete a team
    #
    # In order to delete a team, the authenticated user must be an owner
    # of the org that the team is associated with
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.delete 'team-id'
    #
    def delete(*args)
      arguments(args, required: [:id])

      delete_request("/teams/#{arguments.id}", arguments.params)
    end
    alias :remove :delete

    # List team members
    #
    # In order to list members in a team, the authenticated user
    # must be a member of the team.
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.list_members 'team-id'
    #   github.orgs.teams.list_members 'team-id' { |member| ... }
    #
    # @api public
    def list_members(*args)
      arguments(args, required: [:id])

      response = get_request("/teams/#{arguments.id}/members", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all_members :list_members

    # Check if a user is a member of a team
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.teams.team_member? 'team-id', 'user-name'
    #
    # @api public
    def team_member?(*args)
      arguments(args, required: [:id, :user])

      response = get_request("/teams/#{arguments.id}/members/#{arguments.user}", arguments.params)
      response.status == 204
    rescue Github::Error::NotFound
      false
    end

    # Add a team member
    #
    # In order to add a user to a team, the authenticated user must
    # have ‘admin’ permissions to the team or be an owner of the org
    # that the team is associated with.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.add_member 'team-id', 'user-name'
    #
    # @api public
    def add_member(*args)
      arguments(args, required: [:id, :user])

      put_request("/teams/#{arguments.id}/members/#{arguments.user}", arguments.params)
    end
    alias :add_team_member :add_member

    # Remove a team member
    #
    # In order to remove a user from a team, the authenticated user must
    # have ‘admin’ permissions to the team or be an owner of the org that
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

      delete_request("/teams/#{arguments.id}/members/#{arguments.user}", arguments.params)
    end
    alias :remove_team_member :remove_member

    # List team repositories
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
    alias :repos :list_repos

    # Check if a repository belongs to a team
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
    alias :team_repository? :team_repo?

    # Add a team repository
    #
    # In order to add a repo to a team, the authenticated user must be
    # an owner of the org that the team is associated with. Also, the repo
    # must be owned by the organization, or a direct for of a repo owned
    # by the organization.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.teams.add_repo 'team-id', 'user-name', 'repo-name'
    #
    # @api public
    def add_repo(*args)
      arguments(args, required: [:id, :user, :repo])

      put_request("/teams/#{arguments.id}/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
    alias :add_repository :add_repo

    # Remove a team repository
    #
    # In order to add a repo to a team, the authenticated user must be
    # an owner of the org that the team is associated with.
    # note: This does not delete the repo, it just removes it from the team.
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
    alias :remove_repository :remove_repo
  end # Client::Orgs::Teams
end # Github
