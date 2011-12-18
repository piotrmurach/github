# encoding: utf-8

module Github
  class Orgs < API
    extend AutoloadHelper

    autoload_all 'github_api/orgs',
      :Members => 'members',
      :Teams   => 'teams'

    include Github::Orgs::Members
    include Github::Orgs::Teams

    VALID_ORG_PARAM_NAMES = %w[
      billing_email
      company
      email
      location
      name
    ].freeze

    # Creates new Orgs API
    def initialize(options = {})
      super(options)
    end

    # List all public organizations for a user.
    #
    # = Examples
    #  @github = Github.new :user => 'user-name'
    #  @github.orgs.orgs
    #
    # List public and private organizations for the authenticated user.
    #
    #  @github = Github.new :oauth_token => '..'
    #  @github.orgs.org 'github'
    #
    def orgs(user_name=nil, params={})
      _update_user_repo_params(user_name)
      _normalize_params_keys(params)

      response = if user?
        get("/users/#{user}/orgs", params)
      else
        get("/user/orgs", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_orgs :orgs
    alias :list_organizations :orgs

    # Get properties for a single organization
    #
    # = Examples
    #  @github = Github.new
    #  @github.orgs.org 'github'
    #
    def org(org_name, params={})
      _validate_presence_of org_name
      get("/orgs/#{org_name}", params)
    end
    alias :get_org :org
    alias :organisation :org

    # Edit organization
    #
    # = Parameters
    # <tt>:billing_email</tt> - Optional string - Billing email address. This address is not publicized.
    # <tt>:company</tt> - Optional string
    # <tt>:email</tt> - Optional string
    # <tt>:location</tt> - Optional string
    # <tt>:name</tt> - Optional string
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.orgs.edit_org 'github',
    #    "billing_email" => "support@github.com",
    #    "blog" => "https://github.com/blog",
    #    "company" => "GitHub",
    #    "email" => "support@github.com",
    #    "location" => "San Francisco",
    #    "name" => "github"
    #
    def edit_org(org_name, params={})
      _validate_presence_of org_name
      _normalize_params_keys(params)
      _filter_params_keys(VALID_ORG_PARAM_NAMES, params)

      patch("/orgs/#{org_name}", params)
    end
    alias :edit_organization :edit_org

  end # Orgs
end # Github
