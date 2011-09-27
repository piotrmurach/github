module Github
  class Repos
    module Watching
      
      # List repo watchers
      #
      # GET /repos/:user/:repo/watchers
      #
      def watchers
        get("/repos/#{user}/#{repo}/watchers")
      end
      
      # List repos being watched
      def watched(user=nil)
        if user
          get("/users/#{user}/watched")
        else
          get("/user/watched")
        end
      end

      # Check if you are watching a repo
      #
      # GET /user/watched/:user/:repo
      #
      def watching?(user, repo)
        get("/user/watched/#{user}/#{repo}")
      end

      # Watch a repo 
      #
      # PUT /user/watched/:user/:repo
      #
      def start_watching(user, repo)
        put("/user/watched/#{user}/#{repo}")
      end
      
      # Stop watching a repo
      #
      # DELETE /user/watched/:user/:repo
      #
      def stop_watching(user, repo)
        delete("/user/watched/#{user}/#{repo}")
      end

    end
  end
end
