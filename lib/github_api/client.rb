# encoding: utf-8

module Github
  class Client < API

    def gists(options = {})
      @gists ||= Github::Gists.new(options)
    end

    # The Git Database API gives you access to read and write raw Git objects
    # to your Git database on GitHub and to list and update your references
    # (branch heads and tags).
    def git_data(options = {})
      @git_data ||= Github::GitData.new(options)
    end

    def issues(options = {})
      @issues ||= Github::Issues.new(options)
    end

    def orgs(options = {})
      @orgs ||= Github::Orgs.new(options)
    end

    def pull_requests(options = {})
      @pull_requests ||= Github::PullRequests.new(options)
    end

    def repos(options = {})
      @repos ||= Github::Repos.new(options)
    end

    # Many of the resources on the users API provide a shortcut for getting 
    # information about the currently authenticated user.
    def users(options = {})
      @users ||= Github::Users.new(options)
    end

  end # Client
end # Github
