# encoding: utf-8
require 'cgi'

module Github
  class Users::Emails < API

    # List email addresses for the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.emails.list
    #  github.users.emails.list { |email| ... }
    #
    def list(*args)
      arguments(args)
      response = get_request("/user/emails", arguments.params)
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
      arguments(args)
      params = arguments.params
      params['data'] = arguments.remaining unless arguments.remaining.empty?

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
      arguments(args)
      params = arguments.params
      params['data'] = arguments.remaining unless arguments.remaining.empty?

      delete_request("/user/emails", params)
    end

  end # Users::Emails
end # Github
