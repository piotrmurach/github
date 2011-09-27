module Github
  class Repos
    module Collaborators
      
      # Add collaborator
      #
      # PUT /repos/:user/:repo/collaborators/:user
      # 
      # Examples:
      #  client = Client.new
      #  client.add('user', 'repo', 'collaborator') 
      # 
      def add(user, repo, collaborator)
        put("PUT /repos/#{user}/#{repo}/collaborators/#{collaborator}")
      end
      
      
      # Checks if user is a collaborator for a given repository
      #
      # GET /repos/:user/:repo/collaborators/:user
      #
      def collaborator?(user, repo, collaborator)
        get("/repos/#{user}/#{repo}/collaborators/#{collaborator}")
      end

      # List collaborators
      #
      # GET /repos/:user/:repo/collaborators
      #
      # Examples:
      #   client = Client.new
      #   client.collaborators.list
      def list(user, repo)
        get("/repos/#{user}/#{repo}/collaborators")
      end
      
      # Removes collaborator
      # 
      # DELETE /repos/:user/:repo/collaborators/:user
      #
      def remove(user, repo, collaborator) 
        delete("/repos/#{user}/#{repo}/collaborators/#{user}")
      end

    end # Collaborators
  end # Repos
end # Github
