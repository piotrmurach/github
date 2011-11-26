# encoding: utf-8

module Github
  class Client < API

    def gists(options = {})
      @gists ||= _create_instance Github::Gists, options
    end

    # The Git Database API gives you access to read and write raw Git objects
    # to your Git database on GitHub and to list and update your references
    # (branch heads and tags).
    def git_data(options = {})
      @git_data ||= _create_instance Github::GitData, options
    end
    alias :git :git_data

    def issues(options = {})
      @issues ||= _create_instance Github::Issues, options
    end

    def orgs(options = {})
      @orgs ||= _create_instance Github::Orgs, options
    end
    alias :organizations :orgs

    def pull_requests(options = {})
      @pull_requests ||= _create_instance Github::PullRequests, options
    end

    def repos(options = {})
      @repos ||= _create_instance Github::Repos, options
    end
    alias :repositories :repos

    # Many of the resources on the users API provide a shortcut for getting 
    # information about the currently authenticated user.
    def users(options = {})
      @users ||= _create_instance Github::Users, options
    end

    # An API for users to manage their own tokens. You can only access your own
    # tokens, and only through Basic Authentication.
    def oauth(options = {})
      @oauth ||= _create_instance Github::Authorizations, options
    end

  end # Client
end # Github
