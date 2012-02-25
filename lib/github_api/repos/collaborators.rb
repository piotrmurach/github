# encoding: utf-8

module Github
  class Repos
    module Collaborators

      # Add collaborator
      #
      # Examples:
      #  @github = Github.new
      #  @github.collaborators.add_collaborator 'user', 'repo', 'collaborator'
      #
      #  @repos = Github::Repos.new
      #  @repos.add_collaborator 'user', 'repo', 'collaborator'
      #
      def add_collaborator(user_name, repo_name, collaborator, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of collaborator
        _normalize_params_keys(params)

        put("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
      end
      alias :add_collab :add_collaborator

      # Checks if user is a collaborator for a given repository
      #
      # Examples:
      #  @github = Github.new
      #  @github.collaborators.collaborator?('user', 'repo', 'collaborator')
      #
      def collaborator?(user_name, repo_name, collaborator, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of collaborator
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
        true
      rescue Github::Error::NotFound
        false
      end

      # List collaborators
      #
      # Examples:
      #   @github = Github.new
      #   @github.repos.collaborators 'user-name', 'repo-name'
      #   @github.repos.collaborators 'user-name', 'repo-name' { |cbr| .. }
      #
      def collaborators(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless (user? && repo?)
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/collaborators", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_collaborators :collaborators
      alias :collabs :collaborators

      # Removes collaborator
      #
      # Examples:
      #  @github = Github.new
      #  @github.repos.remove_collaborator 'user', 'repo', 'collaborator'
      #
      def remove_collaborator(user_name, repo_name, collaborator, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of collaborator
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/collaborators/#{collaborator}", params)
      end
      alias :remove_collab :remove_collaborator

    end # Collaborators
  end # Repos
end # Github
