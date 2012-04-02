# encoding: utf-8

module Github
  class Users::Emails < API

    # List email addresses for the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.emails.list
    #  github.users.emails.list { |email| ... }
    #
    def list(params={})
      _normalize_params_keys(params)
      response = get_request("/user/emails", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Add email address(es) for the authenticated user
    #
    # = Inputs
    # You can include a single email address or an array of addresses
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.emails.add "octocat@github.com", "support@github.com"
    #
    def add(*args)
      params = _extract_parameters(args)
      _normalize_params_keys(params)
      params['data'] = [args].flatten if args
      post_request("/user/emails", params)
    end
    alias :<< :add

    # Delete email address(es) for the authenticated user
    #
    # = Inputs
    # You can include a single email address or an array of addresses
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.emails.delete "octocat@github.com", "support@github.com"
    #
    def delete(*args)
      params = _extract_parameters(args)
      _normalize_params_keys(params)
      params['data'] = [args].flatten
      delete_request("/user/emails", params)
    end

  end # Users::Emails
end # Github
