# encoding: utf-8

module Github
  class Client < API

    # This is a read-only API to the GitHub events.
    # These events power the various activity streams on the site.
    def events(options = {})
      @events ||= ApiFactory.new 'Events', options
    end

    def emojis(options = {})
      @emojis ||= ApiFactory.new 'Emojis', options
    end

    def gists(options = {})
      @gists ||= ApiFactory.new 'Gists', options
    end

    # The Git Database API gives you access to read and write raw Git objects
    # to your Git database on GitHub and to list and update your references
    # (branch heads and tags).
    def git_data(options = {})
      @git_data ||= ApiFactory.new 'GitData', options
    end
    alias :git :git_data

    def issues(options = {})
      @issues ||= ApiFactory.new 'Issues', options
    end

    def markdown(options = {})
      @markdown ||= ApiFactory.new 'Markdown', options
    end

    # An API for users to manage their own tokens. You can only access your own
    # tokens, and only through Basic Authentication.
    def oauth(options = {})
      @oauth ||= ApiFactory.new 'Authorizations', options
    end
    alias :authorizations :oauth

    def orgs(options = {})
      @orgs ||= ApiFactory.new 'Orgs', options
    end
    alias :organizations :orgs

    def pull_requests(options = {})
      @pull_requests ||= ApiFactory.new 'PullRequests', options
    end

    def repos(options = {})
      @repos ||= ApiFactory.new 'Repos', options
    end
    alias :repositories :repos

    def search(options = {})
      @search ||= ApiFactory.new 'Search', options
    end

    # Many of the resources on the users API provide a shortcut for getting 
    # information about the currently authenticated user.
    def users(options = {})
      @users ||= ApiFactory.new 'Users', options
    end

  end # Client
end # Github
