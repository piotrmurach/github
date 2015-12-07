# encoding: utf-8

module Github
  # Organizations API
  class Client::Orgs < API

    require_all 'github_api/client/orgs',
                'members',
                'memberships',
                'teams'

    # Access to Client::Orgs::Members API
    namespace :members

    # Access to Client::Orgs::Memberships API
    namespace :memberships

    # Access to Client::Orgs::Teams API
    namespace :teams

    # List all organizations
    #
    # Lists all organizations, in the order that they were created on GitHub.
    #
    # @see https://developer.github.com/v3/orgs/#list-all-organizations
    #
    # @param [Hash] params
    # @option params [String] :since
    #   The integer ID of the last Organization that you've seen.
    #
    # @example
    #   github = Github.new
    #   github.orgs.list :every
    #
    # List all public organizations for a user.
    #
    # @see https://developer.github.com/v3/orgs/#list-user-organizations
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

      if (user_name = params.delete('user'))
        response = get_request("/users/#{user_name}/orgs", params)
      elsif args.map(&:to_s).include?('every')
        response = get_request('/organizations', params)
      else
        # For the authenticated user
        response = get_request('/user/orgs', params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get properties for a single organization
    #
    # @see https://developer.github.com/v3/orgs/#get-an-organization
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
    alias_method :find, :get

    # Edit organization
    #
    # @see https://developer.github.com/v3/orgs/#edit-an-organization
    #
    # @param [Hash] params
    # @option params [String] :billing_email
    #   Billing email address. This address is not publicized.
    # @option params [String] :company
    #   The company name
    # @option params [String] :email
    #   The publicly visible email address
    # @option params [String] :location
    #   The location
    # @option params [String] :name
    #   The shorthand name of the company.
    # @option params [String] :description
    #   The description of the company.
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
      arguments(args, required: [:org_name])

      patch_request("/orgs/#{arguments.org_name}", arguments.params)
    end
  end # Orgs
end # Github
