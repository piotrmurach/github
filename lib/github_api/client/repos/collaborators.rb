# encoding: utf-8

module Github
  class Client::Repos::Collaborators < API
    # List collaborators
    #
    # @example
    #  github = Github.new
    #  github.repos.collaborators.list 'user-name', 'repo-name'
    #
    # @example
    #  github.repos.collaborators.list 'user-name', 'repo-name' { |cbr| .. }
    #
    # @return [Array]
    #
    # @api public
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
    # @example
    #  github = Github.new
    #  github.collaborators.add 'user', 'repo', 'collaborator'
    #
    # @example
    #  collaborators = Github::Repos::Collaborators.new
    #  collaborators.add 'user', 'repo', 'collaborator'
    #
    # @api public
    def add(*args)
      arguments(args, :required => [:user, :repo, :collaborator])
      params = arguments.params

      put_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
    end
    alias :<< :add

    # Checks if user is a collaborator for a given repository
    #
    # @example
    #  github = Github.new
    #  github.repos.collaborators.collaborator?('user', 'repo', 'collaborator')
    #
    # @example
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.collaborators.collaborator? collaborator: 'collaborator'
    #
    # @api public
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
    # @example
    #  github = Github.new
    #  github.repos.collaborators.remove 'user', 'repo', 'collaborator'
    #
    # @api public
    def remove(*args)
      arguments(args, :required => [:user, :repo, :collaborator])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
    end
  end # Client::Repos::Collaborators
end # Github
