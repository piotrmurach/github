# encoding: utf-8

module Github
  module Authorization

    # Setup OAuth2 instance
    def client
      @client ||= ::OAuth2::Client.new(client_id, client_secret,
        {
          :site          => current_options.fetch(:site) { Github.site },
          :authorize_url => 'login/oauth/authorize',
          :token_url     => 'login/oauth/access_token',
          :ssl           => { :verify => false }
        }
      )
    end

    # Strategy token
    def auth_code
      _verify_client
      client.auth_code
    end

    # Sends authorization request to GitHub.
    # = Parameters
    # * <tt>:redirect_uri</tt> - Optional string.
    # * <tt>:scope</tt> - Optional string. Comma separated list of scopes.
    #   Available scopes:
    #   * (no scope) - public read-only access (includes public user profile info, public repo info, and gists).
    #   * <tt>user</tt> - DB read/write access to profile info only.
    #   * <tt>public_repo</tt> - DB read/write access, and Git read access to public repos.
    #   * <tt>repo</tt> - DB read/write access, and Git read access to public and private repos.
    #   * <tt>gist</tt> - write access to gists.
    #
    def authorize_url(params = {})
      _verify_client
      client.auth_code.authorize_url(params)
    end

    # Makes request to token endpoint and retrieves access token value
    def get_token(authorization_code, params = {})
      _verify_client
      client.auth_code.get_token(authorization_code, params)
    end

    # Check whether authentication credentials are present
    def authenticated?
      basic_authed? || oauth_token?
    end

    # Check whether basic authentication credentials are present
    def basic_authed?
      basic_auth? || (login? && password?)
    end

    # Select authentication parameters
    #
    # @api public
    def authentication
      if basic_authed?
        { login: login, password: password }
      else
        {}
      end
    end

    private

    def _verify_client # :nodoc:
      raise ArgumentError, 'Need to provide client_id and client_secret' unless client_id? && client_secret?
    end
  end # Authorization
end # Github
