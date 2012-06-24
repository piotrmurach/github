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
    #  github = Github.new :basic_auth => 'login:password'
    #  github.oauth.list
    #  github.oauth.list { |auth| ... }
    #
    def list(params={})
      _check_if_authenticated
      normalize! params

      response = get_request("/authorizations", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single authorization
    #
    # = Examples
    #  github = Github.new :basic_auth => 'login:password'
    #  github.oauth.get 'authorization-id'
    #
    def get(authorization_id, params={})
      _validate_presence_of(authorization_id)
      _check_if_authenticated
      normalize! params

      get_request("/authorizations/#{authorization_id}", params)
    end
    alias :find :get

    # Create a new authorization
    #
    # = Inputs
    # * <tt>:scopes</tt> - Optional array - A list of scopes that this authorization is in.
    # * <tt>:note</tt> - Optional string - A note to remind you what the OAuth token is for.
    # * <tt>:note_url</tt> - Optional string - A URL to remind you what the OAuth token is for.
    #
    # = Examples
    #  github = Github.new :basic_auth => 'login:password'
    #  github.oauth.create
    #    "scopes" => ["public_repo"]
    #
    def create(params={})
      _check_if_authenticated
      normalize! params
      filter! VALID_AUTH_PARAM_NAMES, params

      post_request("/authorizations", params)
    end

    # Update an existing authorization
    #
    # = Inputs
    # * <tt>:scopes</tt> - Optional array - A list of scopes that this authorization is in.
    # * <tt>:add_scopes</tt> - Optional array - A list of scopes to add to this authorization.
    # * <tt>:remove_scopes</tt> - Optional array - A list of scopes to remove from this authorization.
    # * <tt>:note</tt> - Optional string - A note to remind you what the OAuth token is for.
    # * <tt>:note_url</tt> - Optional string - A URL to remind you what the OAuth token is for.
    #
    # = Examples
    #  github = Github.new :basic_auth => 'login:password'
    #  github.oauth.update "authorization-id", "add_scopes" => ["repo"],
    #
    def update(authorization_id, params={})
      _check_if_authenticated
      _validate_presence_of(authorization_id)

      normalize! params
      filter! VALID_AUTH_PARAM_NAMES, params

      patch_request("/authorizations/#{authorization_id}", params)
    end

    # Delete an authorization
    #
    # = Examples
    #  github.oauth.delete 'authorization-id'
    #
    def delete(authorization_id, params={})
      _check_if_authenticated
      _validate_presence_of(authorization_id)

      normalize! params
      filter! VALID_AUTH_PARAM_NAMES, params

      delete_request("/authorizations/#{authorization_id}", params)
    end
    alias :remove :delete

    private

    def _check_if_authenticated
      raise ArgumentError, 'You can only access authentication tokens through Basic Authentication' unless authenticated?
    end

  end # Authorizations
end # Github
