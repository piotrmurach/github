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
    def list(user_name, repo_name, params={})
      assert_presence_of user_name, repo_name
      normalize! params

      response = get_request("/repos/#{user_name}/#{repo_name}/assignees", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check to see if a particular user is an assignee for a repository.
    #
    # = Examples
    #
    #  Github.issues.assignees.check 'user', 'repo', 'assignee'
    #
    def check(user_name, repo_name, assignee, params={})
      assert_presence_of user_name, repo_name, assignee
      normalize! params

      get_request("/repos/#{user_name}/#{repo_name}/assignees/#{assignee}",params)
      true
    rescue Github::Error::NotFound
      false
    end

  end # Issues::Assignees
end # Github
