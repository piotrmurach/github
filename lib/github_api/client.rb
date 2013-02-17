# encoding: utf-8

module Github
  class Client < API

    # Serving up the ‘social’ in Social Coding™, the Activity APIs
    # provide access to notifications, subscriptions, and timelines.
    #
    def activity(options={}, &block)
      @activity ||= ApiFactory.new('Activity', current_options.merge(options), &block)
    end

    def emojis(options={}, &block)
      @emojis ||= ApiFactory.new('Emojis', current_options.merge(options), &block)
    end

    def gists(options={}, &block)
      @gists ||= ApiFactory.new('Gists', current_options.merge(options), &block)
    end

    def gitignore(options={}, &block)
      @gitignore ||= ApiFactory.new('Gitignore', current_options.merge(options), &block)
    end
    alias :git_ignore :gitignore

    # The Git Database API gives you access to read and write raw Git objects
    # to your Git database on GitHub and to list and update your references
    # (branch heads and tags).
    def git_data(options={}, &block)
      @git_data ||= ApiFactory.new('GitData', current_options.merge(options), &block)
    end
    alias :git :git_data

    def issues(options={}, &block)
      @issues ||= ApiFactory.new('Issues', current_options.merge(options), &block)
    end

    def markdown(options={}, &block)
      @markdown ||= ApiFactory.new('Markdown', current_options.merge(options), &block)
    end

    def meta(options={}, &block)
      @meta ||= ApiFactory.new('Meta', current_options.merge(options), &block)
    end

    # An API for users to manage their own tokens. You can only access your own
    # tokens, and only through Basic Authentication.
    def oauth(options={}, &block)
      @oauth ||= ApiFactory.new('Authorizations', current_options.merge(options), &block)
    end
    alias :authorizations :oauth

    def orgs(options={}, &block)
      @orgs ||= ApiFactory.new('Orgs', current_options.merge(options), &block)
    end
    alias :organizations :orgs

    def pull_requests(options={}, &block)
      @pull_requests ||= ApiFactory.new('PullRequests', current_options.merge(options), &block)
    end
    alias :pulls :pull_requests

    def repos(options={}, &block)
      @repos ||= ApiFactory.new('Repos', current_options.merge(options), &block)
    end
    alias :repositories :repos

    def octocat(options={}, &block)
      @octocat ||= ApiFactory.new('Say', current_options.merge(options), &block)
    end

    def scopes(options={}, &block)
      @scopes ||= ApiFactory.new('Scopes', current_options.merge(options), &block)
    end

    def search(options={}, &block)
      @search ||= ApiFactory.new('Search', current_options.merge(options), &block)
    end

    # Many of the resources on the users API provide a shortcut for getting
    # information about the currently authenticated user.
    #
    def users(options={}, &block)
      @users ||= ApiFactory.new('Users', current_options.merge(options), &block)
    end

  end # Client
end # Github
