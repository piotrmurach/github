# encoding: utf-8

module Github
  class Client::Orgs::Memberships < API
    # List your organization memberships
    #
    # @see List your organization memberships
    #
    # @example
    #   github = Github.new
    #   github.orgs.memberships.list
    #
    # @api public
    def list(*args)
      arguments(args)

      response = get_request('/user/memberships/orgs', arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Add/update user's membership with organization
    #
    # In order to create or update a user's membership with an organization,
    # the authenticated user must be an organization owner.
    #
    # @see https://developer.github.com/v3/orgs/members/#add-or-update-organization-membership
    #
    # @param [String] :org
    # @param [String] :username
    # @param [Hash] options
    # @option options [String] :role
    #   Required. The role to give the user in the organization. Can be one of:
    #     * admin - The user will become an owner of the organization.
    #     * member - The user will become a non-owner member of the organization.
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.orgs.memberhsips.add 'org-name', 'member-name', role: 'role'
    #
    # @api public
    def create(*args)
      arguments(args, required: [:org, :username]) do
        assert_required :role
      end

      put_request("/orgs/#{arguments.org}/memberships/#{arguments.username}",
                  arguments.params)
    end
    alias_method :update, :create
    alias_method :add, :create
  end # Client::Orgs::Memberships
end # Github
