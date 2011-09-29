module Github
  class Repos
    module Collaborators
      
      # Add collaborator
      #
      # PUT /repos/:user/:repo/collaborators/:user
      # 
      # Examples:
      #  github = Github.new
      #  github.collaborators.add_collaborator('user', 'repo', 'collaborator') 
      #
      #  repos = Github::Repos.new
      #  repos.add_collaborator('user', 'repo', 'collaborator')
      #
      def add_collaborator(user, repo, collaborator)
        put("/repos/#{user}/#{repo}/collaborators/#{collaborator}")
      end
      
      
      # Checks if user is a collaborator for a given repository
      #
      # GET /repos/:user/:repo/collaborators/:user
      #
      # Examples:
      #  github = Github.new
      #  github.collaborators.collaborator?('user', 'repo', 'collaborator')
      #
      def collaborator?(user, repo, collaborator)
        get("/repos/#{user}/#{repo}/collaborators/#{collaborator}")
      end

      # List collaborators
      #
      # GET /repos/:user/:repo/collaborators
      #
      # Examples:
      #   github = Github.new
      #   github.repos.collaborators('user', 'repo')
      #
      def collaborators(user, repo)
        get("/repos/#{user}/#{repo}/collaborators")
      end
      
      # Removes collaborator
      # 
      # DELETE /repos/:user/:repo/collaborators/:user
      #
      # Examples:
      #  github = Github.new
      #  github.collaborators.remove('user', 'repo', 'collaborator')
      #
      def remove_collabolator(user, repo, collaborator) 
        delete("/repos/#{user}/#{repo}/collaborators/#{user}")
      end

    end # Collaborators
  end # Repos
end # Github
