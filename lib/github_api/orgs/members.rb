# encoding: utf-8

module Github
  class Orgs
    module Members

      # List members
      #
      # List all users who are members of an organization. A member is a user
      # that belongs to at least 1 team in the organization.
      # If the authenticated user is also a member of this organization then
      # both concealed and public members will be returned.
      # Otherwise only public members are returned.
      #
      # = Examples
      #  @github = Github.new
      #  @github.orgs.members 'org-name'
      #  @github.orgs.members 'org-name' { |memb| ... }
      #
      def members(org_name, params={})
        _validate_presence_of org_name
        _normalize_params_keys(params)
        response = get("/orgs/#{org_name}/members", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_members :members

      # Check if user is a member of an organization
      #
      # = Examples
      #  @github = Github.new
      #  @github.orgs.member? 'org-name', 'member-name'
      #
      def member?(org_name, member_name, params={})
        _validate_presence_of org_name, member_name
        _normalize_params_keys(params)
        get("/orgs/#{org_name}/members/#{member_name}", params)
        true
      rescue Github::ResourceNotFound
        false
      end
      alias :is_member? :member?

      # Remove a member
      # Removing a user from this list will remove them from all teams and
      # they will no longer have any access to the organization’s repositories.
      #
      # = Examples
      #  @github = Github.new
      #  @github.orgs.delete_member 'org-name', 'member-name'
      #
      def delete_member(org_name, member_name, params={})
        _validate_presence_of org_name, member_name
        _normalize_params_keys(params)
        delete("/orgs/#{org_name}/members/#{member_name}", params)
      end
      alias :remove_member :delete_member

      # List public members
      # Members of an organization can choose to have their membership publicized or not.
      # = Examples
      #  @github = Github.new
      #  @github.orgs.public_members 'org-name'
      #  @github.orgs.public_members 'org-name' { |memb| ... }
      #
      def public_members(org_name, params={})
        _validate_presence_of org_name
        _normalize_params_keys(params)
        response = get("/orgs/#{org_name}/public_members")
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_public_members :public_members

      # Get if a user is a public member of an organization
      #
      # = Examples
      #  @github = Github.new
      #  @github.orgs.public_member? 'org-name', 'member-name'
      #
      def public_member?(org_name, member_name, params={})
        _validate_presence_of org_name, member_name
        _normalize_params_keys(params)
        get("/orgs/#{org_name}/public_members/#{member_name}", params)
        true
      rescue Github::ResourceNotFound
        false
      end

      # Publicize a user’s membership
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.publicize 'org-name', 'member-name'
      #
      def publicize(org_name, member_name, params={})
        _validate_presence_of org_name, member_name
        _normalize_params_keys(params)
        put("/orgs/#{org_name}/public_members/#{member_name}", params)
      end
      alias :make_public :publicize
      alias :publicize_membership :publicize

      # Conceal a user’s membership
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.orgs.conceal 'org-name', 'member-name'
      #
      def conceal(org_name, member_name, params={})
        _validate_presence_of org_name, member_name
        _normalize_params_keys(params)
        delete("/orgs/#{org_name}/public_members/#{member_name}", params)
      end
      alias :conceal_membership :conceal

    end # Members
  end # Orgs
end # Github
