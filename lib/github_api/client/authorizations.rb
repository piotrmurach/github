# encoding: utf-8

module Github
  # OAuth Authorizations API
  class Client::Authorizations < API

    require_all 'github_api/client/authorizations', 'app'

    # Access to Authorizations::App API
    namespace :app

    # List authorizations
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#list-your-authorizations
    #
    # @example
    #   github = Github.new basic_auth: 'login:password'
    #   github.oauth.list
    #   github.oauth.list { |auth| ... }
    #
    # @api public
    def list(*args)
      raise_authentication_error unless authenticated?
      arguments(args)

      response = get_request('/authorizations', arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get a single authorization
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#get-a-single-authorization
    #
    # @example
    #  github = Github.new basic_auth: 'login:password'
    #  github.oauth.get 'authorization-id'
    #
    # @return [ResponseWrapper]
    #
    # @api public
    def get(*args)
      raise_authentication_error unless authenticated?
      arguments(args, required: [:id])

      get_request("/authorizations/#{arguments.id}", arguments.params)
    end
    alias_method :find, :get

    # Create a new authorization
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization
    #
    # @param [Hash] params
    # @option params [Array[String]] :scopes
    #   A list of scopes that this authorization is in.
    # @option params [String] :note
    #   Required. A note to remind you what the OAuth token is for.
    # @option params [String] :note_url
    #   A URL to remind you what the OAuth token is for.
    # @option params [String] :client_id
    #   The 20 character OAuth app client key for which to create the token.
    # @option params [String] :client_secret
    #   The 40 character OAuth app client secret for which to create the token.
    # @option params [String] :fingerprint
    #   A unique string to distinguish an authorization from others
    #   created for the same client ID and user.
    #
    # @example
    #   github = Github.new basic_auth: 'login:password'
    #   github.oauth.create scopes: ["public_repo"], note: 'amdmin script'
    #
    # @api public
    def create(*args)
      raise_authentication_error unless authenticated?
      arguments(args) do
        assert_required :note, :scopes
      end

      post_request('/authorizations', arguments.params)
    end

    # Update an existing authorization
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#update-an-existing-authorization
    #
    # @param [Hash] inputs
    # @option inputs [Array] :scopes
    #   Optional array - A list of scopes that this authorization is in.
    # @option inputs [Array] :add_scopes
    #   Optional array - A list of scopes to add to this authorization.
    # @option inputs [Array] :remove_scopes
    #   Optional array - A list of scopes to remove from this authorization.
    # @option inputs [String] :note
    #   Optional string - A note to remind you what the OAuth token is for.
    # @optoin inputs [String] :note_url
    #   Optional string - A URL to remind you what the OAuth token is for.
    # @option params [String] :fingerprint
    #   A unique string to distinguish an authorization from others
    #   created for the same client ID and user.
    #
    # @example
    #   github = Github.new basic_auth: 'login:password'
    #   github.oauth.update "authorization-id", add_scopes: ["repo"]
    #
    # @api public
    def update(*args)
      raise_authentication_error unless authenticated?
      arguments(args, required: [:id])

      patch_request("/authorizations/#{arguments.id}", arguments.params)
    end
    alias_method :edit, :update

    # Delete an authorization
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#delete-an-authorization
    #
    # @example
    #   github = Github.new
    #   github.oauth.delete 'authorization-id'
    #
    # @api public
    def delete(*args)
      raise_authentication_error unless authenticated?
      arguments(args, required: [:id])

      delete_request("/authorizations/#{arguments.id}", arguments.params)
    end
    alias_method :remove, :delete

    protected

    def raise_authentication_error
      raise ArgumentError, 'You can only access your own tokens' \
                           ' via Basic Authentication'
    end
  end # Client::Authorizations
end # Github
