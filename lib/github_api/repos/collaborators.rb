# encoding: utf-8

module Github
  class Repos::Collaborators < API

    # List collaborators
    #
    # Examples:
    #  github = Github.new
    #  github.repos.collaborators.list 'user-name', 'repo-name'
    #  github.repos.collaborators.list 'user-name', 'repo-name' { |cbr| .. }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/collaborators", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Add collaborator
    #
    # Examples:
    #  github = Github.new
    #  github.collaborators.add 'user', 'repo', 'collaborator'
    #
    #  collaborators = Github::Repos::Collaborators.new
    #  collaborators.add 'user', 'repo', 'collaborator'
    #
    def add(*args)
      arguments(args, :required => [:user, :repo, :collaborator])
      params = arguments.params

      put_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
    end
    alias :<< :add

    # Checks if user is a collaborator for a given repository
    #
    # Examples:
    #  github = Github.new
    #  github.repos.collaborators.collaborator?('user', 'repo', 'collaborator')
    #
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.collaborators.collaborator? collaborator: 'collaborator'
    #
    def collaborator?(*args)
      arguments(args, :required => [:user, :repo, :collaborator])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Removes collaborator
    #
    # Examples:
    #  github = Github.new
    #  github.repos.collaborators.remove 'user', 'repo', 'collaborator'
    #
    def remove(*args)
      arguments(args, :required => [:user, :repo, :collaborator])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
    end

  end # Repos::Collaborators
end # Github
