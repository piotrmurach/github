module Github
  class Client < API

    def gists
      puts "gists"
    end

    def git_data

    end

    def issues

    end

    def orgs

    end

    def pull_requests

    end

    def repos(options = {})
      @repos ||= Github::Repos.new(options)
    end

    def users

    end

  end
end
