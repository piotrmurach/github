# encoding: utf-8

module Github
  class Orgs < API

    Github::require_all 'github_api/orgs',
      'members',
      'teams'

    VALID_ORG_PARAM_NAMES = %w[
      billing_email
      company
      email
      location
      name
    ].freeze

    # Access to Orgs::Members API
    def members(options={}, &block)
      @members ||= ApiFactory.new('Orgs::Members', current_options.merge(options), &block)
    end

    # Access to Orgs::Teams API
    def teams(options={}, &block)
      @teams ||= ApiFactory.new('Orgs::Teams', current_options.merge(options), &block)
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
      params = arguments(args).params

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
    def get(*args)
      arguments(args, :required => [:org_name])

      get_request("/orgs/#{org_name}", arguments.params)
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
    #  github = Github.new oauth_token: '...'
    #  github.orgs.edit 'github',
    #    "billing_email": "support@github.com",
    #    "blog": "https://github.com/blog",
    #    "company": "GitHub",
    #    "email": "support@github.com",
    #    "location": "San Francisco",
    #    "name": "github"
    #
    def edit(*args)
      arguments(args, :required => [:org_name]) do
        sift VALID_ORG_PARAM_NAMES
      end

      patch_request("/orgs/#{org_name}", arguments.params)
    end

  end # Orgs
end # Github
