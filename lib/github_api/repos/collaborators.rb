# encoding: utf-8

module Github
  class Repos::Collaborators < API

    # Add collaborator
    #
    # Examples:
    #  github = Github.new
    #  github.collaborators.add 'user', 'repo', 'collaborator'
    #
    #  collaborators = Github::Repos::Collaborators.new
    #  collaborators.add 'user', 'repo', 'collaborator'
    #
    def add(user_name, repo_name, collaborator, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, collaborator
      normalize! params

      put_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
    end
    alias :<< :add

    # Checks if user is a collaborator for a given repository
    #
    # Examples:
    #  github = Github.new
    #  github.collaborators.collaborator?('user', 'repo', 'collaborator')
    #
    def collaborator?(user_name, repo_name, collaborator, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo, collaborator
      normalize! params

      get_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # List collaborators
    #
    # Examples:
    #  github = Github.new
    #  github.repos.collaborators.list 'user-name', 'repo-name'
    #  github.repos.collaborators.list 'user-name', 'repo-name' { |cbr| .. }
    #
    def list(user_name, repo_name, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of user, repo
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/collaborators", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Removes collaborator
    #
    # Examples:
    #  github = Github.new
    #  github.repos.collaborators.remove 'user', 'repo', 'collaborator'
    #
    def remove(user_name, repo_name, collaborator, params={})
      set :user => user_name, :repo => repo_name
      assert_presence_of collaborator
      normalize! params

      delete_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
    end

  end # Repos::Collaborators
end # Github
