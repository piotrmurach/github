# encoding: utf-8

module Github
  class Client::Authorizations::App < Client::Authorizations
    # Get-or-create an authorization for a specific app
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#get-or-create-an-authorization-for-a-specific-app
    #
    # @param [Hash] params
    # @option params [String] client_secret
    #  The 40 character OAuth app client secret associated with the client
    #  ID specified in the URL.
    # @option params [Array] :scopes
    #   Optional array - A list of scopes that this authorization is in.
    # @option params [String] :note
    #   Optional string - A note to remind you what the OAuth token is for.
    # @option params [String] :note_url
    #   Optional string - A URL to remind you what the OAuth token is for.
    #
    # @example
    #   github = Github.new
    #   github.oauth.app.create 'client-id', client_secret: '...'
    #
    # @api public
    def create(*args)
      raise_authentication_error unless authenticated?
      arguments(args, required: [:client_id])

      if arguments.client_id
        put_request("/authorizations/clients/#{arguments.client_id}", arguments.params)
      else
        raise raise_app_authentication_error
      end
    end

    # Check if an access token is a valid authorization for an application
    #
    # @example
    #   github = Github.new basic_auth: "client_id:client_secret"
    #   github.oauth.app.check 'client_id', 'access-token'
    #
    # @api public
    def check(*args)
      raise_authentication_error unless authenticated?
      params = arguments(args, required: [:client_id, :access_token]).params

      if arguments.client_id
        begin
          get_request("/applications/#{arguments.client_id}/tokens/#{arguments.access_token}", params)
        rescue Github::Error::NotFound => e
          nil
        end
      else
        raise raise_app_authentication_error
      end
    end

    # Revoke all authorizations for an application
    #
    # @example
    #  github = Github.new basic_auth: "client_id:client_secret"
    #  github.oauth.app.delete 'client-id'
    #
    # Revoke an authorization for an application
    #
    # @example
    #  github = Github.new basic_auth: "client_id:client_secret"
    #  github.oauth.app.delete 'client-id', 'access-token'
    #
    # @api public
    def delete(*args)
      raise_authentication_error unless authenticated?
      params = arguments(args, required: [:client_id]).params

      if arguments.client_id
        if access_token = (params.delete('access_token') || args[1])
          delete_request("/applications/#{arguments.client_id}/tokens/#{access_token}", params)
        else
          # Revokes all tokens
          delete_request("/applications/#{arguments.client_id}/tokens", params)
        end
      else
        raise raise_app_authentication_error
      end
    end
    alias :remove :delete
    alias :revoke :delete

    protected

    def raise_app_authentication_error
      raise ArgumentError, 'To create authorization for the app, ' +
        'you need to provide client_id argument and client_secret parameter'
    end
  end # Client::Authorizations::App
end # Github
