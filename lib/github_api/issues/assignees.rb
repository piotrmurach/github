# encoding: utf-8

module Github
  class Issues::Assignees < API

    # lists all the available assignees (owner + collaborators)
    # to which issues may be assigned.
    #
    # = Examples
    #
    #  Github.issues.assignees.list 'user', 'repo'
    #  Github.issues.assignees.list 'user', 'repo' { |assignee| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/assignees", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Check to see if a particular user is an assignee for a repository.
    #
    # = Examples
    #
    #  Github.issues.assignees.check 'user', 'repo', 'assignee'
    #
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.issues.assignees.check 'assignee'
    #
    def check(*args)
      arguments(args, :required => [:user, :repo, :assignee])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/assignees/#{assignee}",params)
      true
    rescue Github::Error::NotFound
      false
    end

  end # Issues::Assignees
end # Github
