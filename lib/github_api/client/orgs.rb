# encoding: utf-8

module Github
  class Client::Orgs < API

    require_all 'github_api/client/orgs',
      'members',
      'teams'

    VALID_ORG_PARAM_NAMES = %w[
      billing_email
      company
      email
      location
      name
    ].freeze

    # Access to Client::Orgs::Members API
    namespace :members

    # Access to Client::Orgs::Teams API
    namespace :teams

    # List all public organizations for a user.
    #
    # @example
    #   github = Github.new
    #   github.orgs.list user: 'user-name'
    #
    # List public and private organizations for the authenticated user.
    #
    # @example
    #   github = Github.new oauth_token: '..'
    #   github.orgs.list
    #
    # @api public
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
    # @example
    #  github = Github.new
    #  github.orgs.get 'github'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:org_name])

      get_request("/orgs/#{arguments.org_name}", arguments.params)
    end
    alias :find :get

    # Edit organization
    #
    # @param [Hash] params
    # @input params [String] :billing_email
    #   Billing email address. This address is not publicized.
    # @input params [String] :company
    #   The company name
    # @input params [String] :email
    #   The publicly visible email address
    # @input params [String] :location
    #   The location
    # @input params [String] :name
    #   The shorthand name of the company.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.orgs.edit 'github',
    #    billing_email: "support@github.com",
    #    blog: "https://github.com/blog",
    #    company: "GitHub",
    #    email: "support@github.com",
    #    location: "San Francisco",
    #    name: "github"
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:org_name]) do
        permit VALID_ORG_PARAM_NAMES
      end

      patch_request("/orgs/#{arguments.org_name}", arguments.params)
    end
  end # Orgs
end # Github
