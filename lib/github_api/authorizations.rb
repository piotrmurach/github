# encoding: utf-8

module Github
  class Authorizations < API

    VALID_AUTH_PARAM_NAMES = %w[
      scopes
      add_scopes
      remove_scopes
    ].freeze

    # Creates new OAuth Authorizations API
    def initialize(options = {})
      super(options)
    end

    # List authorizations
    #
    # = Examples
    #  @github = Github.new :basic_auth => 'login:password'
    #  @github.oauth.authorizations
    #  @github.oauth.authorizations { |auth| ... }
    #
    def authorizations(params={})
      _check_if_authenticated
      _normalize_params_keys(params)

      response = get("/authorizations", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :auths :authorizations
    alias :list_auths :authorizations
    alias :list_authorizations :authorizations

    # Get a single authorization
    #
    # = Examples
    #  @github = Github.new :basic_auth => 'login:password'
    #  @github.oauth.authorization 'authorization-id'
    #
    def authorization(authorization_id, params={})
      _validate_presence_of(authorization_id)
      _check_if_authenticated
      _normalize_params_keys params

      get "/authorizations/#{authorization_id}", params
    end
    alias :auth :authorization
    alias :get_auth :authorization
    alias :get_authorization :authorization

    # Create a new authorization
    #
    # = Inputs
    # * <tt>:scopes</tt> - Optional array - A list of scopes that this authorization is in.
    # = Examples
    #  @github = Github.new :basic_auth => 'login:password'
    #  @github.oauth.create_authorization
    #    "scopes" => ["public_repo"]
    #
    def create_authorization(params={})
      _check_if_authenticated
      _normalize_params_keys(params)
      _filter_params_keys(VALID_AUTH_PARAM_NAMES, params)

      post("/authorizations", params)
    end
    alias :create_auth :create_authorization

    # Update an existing authorization
    #
    # = Inputs
    # * <tt>:scopes</tt> - Optional array - A list of scopes that this authorization is in.
    # * <tt>:add_scopes</tt> - Optional array - A list of scopes to add to this authorization.
    # * <tt>:remove_scopes</tt> - Optional array - A list of scopes to remove from this authorization.
    #
    # = Examples
    #  @github = Github.new :basic_auth => 'login:password'
    #  @github.oauth.update_authorization
    #    "add_scopes" => ["repo"],
    #
    def update_authorization(authorization_id, params={})
      _check_if_authenticated
      _validate_presence_of(authorization_id)

      _normalize_params_keys(params)
      _filter_params_keys(VALID_AUTH_PARAM_NAMES, params)

      patch("/authorizations/#{authorization_id}", params)
    end
    alias :update_auth :update_authorization

    # Delete an authorization
    #
    # = Examples
    #  @github.oauth.delete_authorization 'authorization-id'
    #
    def delete_authorization(authorization_id, params={})
      _check_if_authenticated
      _validate_presence_of(authorization_id)

      _normalize_params_keys(params)
      _filter_params_keys(VALID_AUTH_PARAM_NAMES, params)

      delete("/authorizations/#{authorization_id}", params)
    end
    alias :delete_auth :delete_authorization
    alias :remove_auth :delete_authorization
    alias :remove_authorization :delete_authorization

    private

    def _check_if_authenticated
      raise ArgumentError, 'You can only access authentication tokens through Basic Authentication' unless authenticated?
    end

  end # Authorizations
end # Github
