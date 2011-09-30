module Github
  class Repos
    module Collaborators
      
      # Add collaborator
      #
      # Examples:
      #  @github = Github.new
      #  @github.collaborators.add_collaborator('user', 'repo', 'collaborator') 
      #
      #  @repos = Github::Repos.new
      #  @repos.add_collaborator('user', 'repo', 'collaborator')
      #
      def add_collaborator(user, repo, collaborator)
        put("/repos/#{user}/#{repo}/collaborators/#{collaborator}")
      end
      
      
      # Checks if user is a collaborator for a given repository
      #
      # Examples:
      #  @github = Github.new
      #  @github.collaborators.collaborator?('user', 'repo', 'collaborator')
      #
      def collaborator?(user_name, repo_name, collaborator)
        get("/repos/#{user}/#{repo}/collaborators/#{collaborator}")
      end

      # List collaborators
      #
      # Examples:
      #   @github = Github.new
      #   @github.repos.collaborators('user-name', 'repo-name')
      #   @github.repos.collaborators('user-name', 'repo-name') { |cbr| .. }
      #
      def collaborators(user_name=nil, repo_name=nil)
        _update_user_repo_params(user_name, repo_name)      
        _validate_user_repo_params(user, repo) unless (user? && repo?)
        
        response = get("/repos/#{user}/#{repo}/collaborators")
        return response unless block_given?
        response.each { |el| yield el }
      end
      
      # Removes collaborator
      #
      # Examples:
      #  @github = Github.new
      #  @github.collaborators.remove('user', 'repo', 'collaborator')
      #
      def remove_collabolator(user, repo, collaborator) 
        delete("/repos/#{user}/#{repo}/collaborators/#{user}")
      end

    end # Collaborators
  end # Repos
end # Github
