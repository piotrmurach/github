# encoding: utf-8

module Github
  class Client::Scopes < API
    # Check what OAuth scopes you have.
    #
    # @see https://developer.github.com/v3/oauth/#scopes
    #
    # @example
    #   github = Github.new oauth_token: 'e72e16c7e42f292c6912e7710c838347ae17'
    #   github.scopes.all
    #
    # @example
    #   github = Github.new
    #   github.scopes.list 'e72e16c7e42f292c6912e7710c838347ae17'
    #
    # @example
    #   github = Github.new
    #   github.scopes.list token: 'e72e16c7e42f292c6912e7710c838347ae17'
    #
    # @api public
    def list(*args)
      arguments(args)
      params = arguments.params
      token = args.shift

      if token.is_a?(Hash) && !params['token'].nil?
        token = params.delete('token')
      elsif token.nil?
        token = oauth_token
      end

      if token.nil?
        raise ArgumentError, 'Access token required'
      end

      headers = { 'Authorization' => "token #{token}" }
      params['headers'] = headers
      response = get_request("/user", params)
      response.headers.oauth_scopes.split(',').map(&:strip)
    end
    alias all list
  end # Client::Scopes
end # Github
