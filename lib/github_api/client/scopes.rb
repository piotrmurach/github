# encoding: utf-8

module Github
  class Client::Scopes < API
    # Check what OAuth scopes you have.
    #
    # = Examples
    #  github = Github.new :oauth_token => 'token'
    #  github.scopes.all
    #
    def list(*args)
      arguments(args)
      response = get_request("/user", arguments.params)
      response.headers.oauth_scopes ? response.headers.oauth_scopes.split(',') : response
    end
    alias :all :list
  end
end # Github
