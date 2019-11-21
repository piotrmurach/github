# encoding: utf-8

require_relative '../../api'

module Github
  class Client::Repos::Invitations < API
    # List repo invitations
    #
    # @example
    #  github = Github.new
    #  github.repos.invitations.list 'user-name', 'repo-name'
    #
    # @example
    #  github.repos.invitations.list 'user-name', 'repo-name' { |cbr| .. }
    #
    # @return [Array]
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/invitations", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Deletes a repo invitation
    #
    # @example
    #   github = Github.new
    #   github.repos.invitations.delete 'user-name', 'repo-name', 'invitation-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :id])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/invitations/#{arguments.id}", arguments.params)
    end
  end
end
