# encoding: utf-8

module Github
  class Client::Repos::Collaborators < API
    # List collaborators
    #
    # When authenticating as an organization owner of an
    # organization-owned repository, all organization owners are included
    # in the list of collaborators. Otherwise, only users with access to the
    # repository are returned in the collaborators list.
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
      arguments(args, required: [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/collaborators", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Add collaborator
    #
    # @example
    #  github = Github.new
    #  github.repos.collaborators.add 'user', 'repo', 'username'
    #
    # @example
    #  collaborators = Github::Repos::Collaborators.new
    #  collaborators.add 'user', 'repo', 'username'
    #
    # @api public
    def add(*args)
      arguments(args, required: [:user, :repo, :username])

      put_request("/repos/#{arguments.user}/#{arguments.repo}/collaborators/#{arguments.username}", arguments.params)
    end
    alias :<< :add

    # Checks if user is a collaborator for a given repository
    #
    # @example
    #  github = Github.new
    #  github.repos.collaborators.collaborator?('user', 'repo', 'username')
    #
    # @example
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.collaborators.collaborator? username: 'collaborator'
    #
    # @api public
    def collaborator?(*args)
      arguments(args, required: [:user, :repo, :username])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/collaborators/#{arguments.username}", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Removes collaborator
    #
    # @example
    #  github = Github.new
    #  github.repos.collaborators.remove 'user', 'repo', 'username'
    #
    # @api public
    def remove(*args)
      arguments(args, required: [:user, :repo, :username])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/collaborators/#{arguments.username}", arguments.params)
    end
  end # Client::Repos::Collaborators
end # Github
