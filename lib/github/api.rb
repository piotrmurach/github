module Github
  class API
    
    include Connection 
    include Request

    include Repos
  
    def initialize

    end

    private

    def _validate_user_repo_params

    end
  end
end
