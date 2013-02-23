# encoding: utf-8

module Github
  class Authorizations < API

    VALID_AUTH_PARAM_NAMES = %w[
      scopes
      add_scopes
      remove_scopes
      note
      note_url
      client_id
      client_secret
    ].freeze

    # List authorizations
    #
    # = Examples
    #  github = Github.new :basic_auth => 'login:password'
    #  github.oauth.list
    #  github.oauth.list { |auth| ... }
    #
    def list(*args)
      _check_if_authenticated
      arguments(args)

      response = get_request("/authorizations", arguments.params)
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
    def get(*args)
      _check_if_authenticated
      arguments(args, :required => [:authorization_id])

      get_request("/authorizations/#{authorization_id}", arguments.params)
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
    def create(*args)
      _check_if_authenticated
      arguments(args) do
        sift VALID_AUTH_PARAM_NAMES
      end

      post_request("/authorizations", arguments.params)
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
    def update(*args)
      _check_if_authenticated
      arguments(args, :required => [:authorization_id]) do
        sift VALID_AUTH_PARAM_NAMES
      end

      patch_request("/authorizations/#{authorization_id}", arguments.params)
    end
    alias :edit :update

    # Delete an authorization
    #
    # = Examples
    #  github.oauth.delete 'authorization-id'
    #
    def delete(*args)
      _check_if_authenticated
      arguments(args, :required => [:authorization_id])

      delete_request("/authorizations/#{authorization_id}", arguments.params)
    end
    alias :remove :delete

    private

    def _check_if_authenticated
      raise ArgumentError, 'You can only access authentication tokens through Basic Authentication' unless authenticated?
    end

  end # Authorizations
end # Github
