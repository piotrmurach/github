# encoding: utf-8

module Github
  class Orgs < API
    extend AutoloadHelper

    autoload_all 'github_api/orgs',
      :Members => 'members',
      :Teams   => 'teams'

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

    # Access to Orgs::Members API
    def members
      @members ||= ApiFactory.new 'Orgs::Members'
    end

    # Access to Orgs::Teams API
    def teams
      @teams ||= ApiFactory.new 'Orgs::Teams'
    end

    # List all public organizations for a user.
    #
    # = Examples
    #  github = Github.new
    #  github.orgs.list user: 'user-name'
    #
    # List public and private organizations for the authenticated user.
    #
    #  github = Github.new oauth_token: '..'
    #  github.orgs.list
    #
    def list(*args)
      params = args.extract_options!
      normalize! params

      response = if (user_name = params.delete("user"))
        get_request("/users/#{user_name}/orgs", params)
      else
        # For the authenticated user
        get_request("/user/orgs", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get properties for a single organization
    #
    # = Examples
    #  github = Github.new
    #  github.orgs.get 'github'
    #
    def get(org_name, params={})
      _validate_presence_of org_name
      normalize! params
      get_request("/orgs/#{org_name}", params)
    end
    alias :find :get

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
    #  github = Github.new :oauth_token => '...'
    #  github.orgs.edit 'github',
    #    "billing_email" => "support@github.com",
    #    "blog" => "https://github.com/blog",
    #    "company" => "GitHub",
    #    "email" => "support@github.com",
    #    "location" => "San Francisco",
    #    "name" => "github"
    #
    def edit(org_name, params={})
      _validate_presence_of org_name
      normalize! params
      filter! VALID_ORG_PARAM_NAMES, params

      patch_request("/orgs/#{org_name}", params)
    end

  end # Orgs
end # Github
