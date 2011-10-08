# encoding: utf-8

module Github
  class Client < API

    def gists(options = {})
      @gists ||= Github::Gists.new(options)
    end

    def git_data(options)
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

    def users(options = {})
      @users ||= Github::Users.new(options)
    end

  end # Client
end # Github
