module Github
  class Repos
    module Forks
      
      # List forks 
      #
      # GET /repos/:user/:repo/forks
      #
      # Examples
      #
      def list(user, repo)
        get("/repos/#{user}/#{repo}/forks")
      end
      
      # Create a fork for the authenticated user
      # 
      # POST /repos/:user/:repo/forks
      #
      def create(user, repo, params={})
        _normalize_params_keys(params)
        _filter_params_keys(%w[ org ], params)

        post("/repos/#{user}/#{repo}/forks", params)
      end
    end
  end
end # Github
