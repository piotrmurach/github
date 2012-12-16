# encoding: utf-8

module Github
  class Scopes < API

    # Check what OAuth scopes you have.
    #
    # = Examples
    #  github = Github.new :oauth_token => 'token'
    #  github.scopes.all
    #
    def list(params={})
      response = get_request("/user", params)
      response.oauth_scopes ? response.oauth_scopes.split(',') : response
    end
    alias :all :list

  end
end # Github
