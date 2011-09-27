module Github
  class Repos < API
    
    include Github::Repos::Collaborators
    include Repos::Commits
    include Repos::Downloads
    include Repos::Forks
    include Repos::Hooks
    include Repos::Keys
    include Repos::Watching

    DEFAULT_REPO_OPTIONS = {
      "homepage"   => "https://github.com",
      "public"     => true,
      "has_issues" => true,
      "has_wiki"   => true,
      "has_downloads" => true
    }

    VALID_REPO_TYPES = %w[ all public private member ]

    # List branches
    #
    # GET /repos/:user/:repo/branches
    #
    def branches(user, repo, params={})
      _validate_user_repo_params
      response = get("/repos#{user}/#{repo}", options)
    end

    def collaborators(user, repo)
      
    end

    def commits

    end

    # Create a new repository for the autheticated user
    #
    # POST /user/repos
    #
    # Examples:
    #   client = Client.new
    #   client.create(:name => 'my_repo_name')
    #
    #
    # Create a new repository in this organisation. The authenticated user 
    # must be a member of this organisation
    # 
    # POST /orgs/:org/repos
    #
    # Examples:
    #   client = Client.new
    #   client.create('my-repo-name', :org => 'my-organisation')
    # 
    def create(name, params = {})
      DEFAULT_REPO_OPTIONS.merge(params)
      if (org = params.delete("org")) 
        post("/orgs/#{org}/repos", params)
      else
        post("/user/repos", params)
      end
    end
    
    # List contributors 
    #
    # GET /repos/:user/:repo/contributors
    # 
    # Examples:
    #    client = Client.new
    #    client.contributors(:user => 'john', :role => 'twitter')
    def contributors(user, repo, flag=nil)
      get("/repos/#{user}/#{repo}/contributors", flag)
    end
    
    # Provides access to Github::Repos::Downloads
    def downloades
      
    end

    # Edit a repository
    # 
    # POST /repos/:user/:repo
    #
    # Examples:
    #   client = Client.new
    #   client.edit
    # 
    def edit(user, repo, name, params = {})
      post("/repos/#{user}/#{repo}", params)  
    end
    
    # Provides access to Github::Repos::Forks
    def forks

    end
    
    # Get a repository
    # 
    # GET /repos/:user/:repo
    # 
    # Examples:
    # 
    #  client = Client.new
    #  client.get_repo('my-username', 'my-repo-name')
    #
    def get(user, repo)
      get("/repos/#{user}/#{repo}")  # TODO change request methods CLASH!!!
    end

    # Provides access to Github::Repos::Keys
    def keys
       
    end

    # List languages
    #
    #  GET /repos/:user/:repo/languages
    def languages(user, repo)
      get("/repos/#{user}/#{repo}/languages")
    end

    # List repositories for the authenticated user
    #
    # GET /user/repos
    # 
    #
    # List public repositories for the specified user.
    # 
    # GET /users/:user/repos
    #
    # Examples:
    #   github = Github.new
    #   github.repos.list(:user => 'username')
    #
    # List repositories for the specified organisation.
    #
    # GET /orgs/:org/repos
    #
    # Examples:
    #
    def list(params = {})
      type = params["type"]
      raise ArgumentError, "unkown repository type, only valid are: #{VALID_REPO_TYPES.join(' ')}" if VALID_REPO_TYPES.include? 
      if (user = params.delete("user"))
        get("/users/#{user}/repos")
      elsif (org = params.delete("org"))
        get("/users/#{user}/repos", params)
      else
        get("/user/repos", params)
      end
    end
    
    # List tags
    #
    # GET /repos/:user/:repo/tags
    # 
    def tags(params={})
      get("/repos/#{user}/#{repo}/tags")
    end
    
    # List teams
    #
    # GET /repos/:user/:repo/teams
    def teams(user, repo)
      get("/repos/#{user}/#{repo}/teams")
    end
  
  end # Repos
end # Github
