# encoding: utf-8

require 'oauth2'

module Github
  module Authorization

    attr_accessor :scopes

    # Setup OAuth2 instance
    def client
      debugger
      @client ||= ::OAuth2::Client.new(client_id, client_secret,
        :site => 'https://github.com/login/oauth/authorize',
        :authorize_url => 'login/oauth/authorize',
        :token_url     => 'login/oauth/access_token'
      )
    end

    # Strategy token
    def auth_code
      @client.oauth_code
    end

    # Sends authorization request to GitHub.
    # = Parameters
    # * <tt>:redirect_uri</tt> - Required string.
    # * <tt>:scope</tt> - Optional string. Comma separated list of scopes.
    #   Available scopes:
    #   * (no scope) - public read-only access (includes public user profile info, public repo info, and gists).
    #   * <tt>user</tt> - DB read/write access to profile info only.
    #   * <tt>public_repo</tt> - DB read/write access, and Git read access to public repos.
    #   * <tt>repo</tt> - DB read/write access, and Git read access to public and private repos.
    #   * <tt>gist</tt> - write access to gists.
    #
    def authorize_url(params = {})
      @client.auth_code.authorize_url(params)
    end

    # Makes request to token endpoint and retrieves access token value
    def get_token(authorization_code, params = {})
      @client.auth_code.get_token(authorization_code, params)
    end

  end # Authorization
end # Github
