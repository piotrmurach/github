# encoding: utf-8

module Github
  class Repos < API
    extend AutoloadHelper
    
    # Load all the modules after initializing Repos to avoid superclass mismatch
    autoload_all 'github/repos',
      :Collaborators => 'collaborators',
      :Commits       => 'commits',
      :Downloads     => 'downloads',
      :Forks         => 'forks',
      :Hooks         => 'hooks',
      :Keys          => 'keys',
      :Watching      => 'watching'

    include Github::Repos::Collaborators
    include Github::Repos::Commits
    include Github::Repos::Downloads
    include Github::Repos::Forks
    include Github::Repos::Hooks
    include Github::Repos::Keys
    include Github::Repos::Watching

    DEFAULT_REPO_OPTIONS = {
      "homepage"   => "https://github.com",
      "public"     => true,
      "has_issues" => true,
      "has_wiki"   => true,
      "has_downloads" => true
    }

    VALID_REPO_OPTIONS = %w[ name description homepage public has_issues has_wiki has_downloads ]

    VALID_REPO_TYPES = %w[ all public private member ]
    
    # Creates new Repos API
    def initialize(options = {})
      super(options)
    end

    # List branches
    #
    # = Examples
    # 
    #   @github = Github.new
    #   @github.repos.branches('user-name', 'repo-name')
    #
    #   @repos = Github::Repos.new
    #   @repos.branches('user-name', 'repo-name')
    #
    def branches(user_name=nil, repo_name=nil)
      _validate_user_repo_params(user_name, repo_name) unless user? && repo?
      _update_user_repo_params(user_name, repo_name)      

      response = get("/repos/#{user}/#{repo}/branches")
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Create a new repository for the autheticated user.
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.create_repo.create(:name => 'my_repo_name')
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
    def create_repo(name, params = {})
      DEFAULT_REPO_OPTIONS.merge(params)
      if (org = params.delete("org")) 
        post("/orgs/#{org}/repos", params)
      else
        post("/user/repos", params)
      end
    end
    
    # List contributors 
    #
    # = Parameters
    #  :anon - Optional flag. Set to 1 or true to include anonymous contributors. 
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.contributors('user-name','repo-name')
    #  @github.repos.contributors('user-name','repo-name') { |cont| ... }
    #
    def contributors(user, repo, params={})
      _validate_user_repo_params(user_name, repo_name) unless user? && repo?
      _update_user_repo_params(user_name, repo_name)      
      _normalize_params_keys(params)
      _filter_params_keys(['anon'], params)

      response = get("/repos/#{user}/#{repo}/contributors", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Edit a repository
    #
    # = Parameters
    #  :name        Required string
    #  :description Optional string
    #  :homepage    Optional string
    #  :public      Optional boolean - true to create public repo, false to create a private one
    #  :has_issues  Optional boolean - <tt>true</tt> to enable issues for this repository, <tt>false</tt> to disable them
    #  :has_wiki    Optional boolean - <tt>true</tt> to enable the wiki for this repository, <tt>false</tt> to disable it. Default is <tt>true</tt>
    #  :has_downloads Optional boolean - <tt>true</tt> to enable downloads for this repository 
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.edit_repo('user-name', 'repo-name', { :name => 'hello-world', :description => 'This is your first repo', :homepage => "https://github.com", :public => true, :has_issues => true })
    # 
    def edit_repo(user=nil, repo=nil, params={})
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)
      _filter_params_keys(VALID_REPO_OPTIONS, params)

      DEFAULT_REPO_OPTIONS.merge(params)

      patch("/repos/#{user}/#{repo}", params)  
    end
    
    # Get a repository
    # 
    # = Examples
    #  @github = Github.new
    #  @github.repos.get_repo('user-name', 'repo-name')
    #
    def get_repo(user_name, repo_name)
      _validate_user_repo_params(user_name, repo_name) unless user? && repo?
      _update_user_repo_params(user_name, repo_name)      

      get("/repos/#{user}/#{repo}")
    end

    # List languages
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.languages('user-name', 'repo-name')
    #  @github.repos.languages('user-name', 'repo-name') { |lang| ... }
    #
    def languages(user_name, repo_name)
      _validate_user_repo_params(user_name, repo_name) unless user? && repo?
      _update_user_repo_params(user_name, repo_name)      

      response = get("/repos/#{user}/#{repo}/languages")
      return response unless block_given?
      response.each { |el| yield el }
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
    def list_repos(params = {})
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
    # = Examples
    #   @github = Github.new
    #   @github.repos.tags('user-name', 'repo-name')
    #   @github.repos.tags('user-name', 'repo-name') { |tag| ... }
    #
    def tags(user_name=nil, repo_name=nil)
      _validate_user_repo_params(user_name, repo_name) unless user? && repo?
      _update_user_repo_params(user_name, repo_name)      

      response = get("/repos/#{user}/#{repo}/tags")
      return response unless block_given?
      response.each { |el| yield el }
    end
    
    # List teams
    #
    # == Examples
    #   @github = Github.new
    #   @github.repos.teams('user-name', 'repo-name')
    #   @github.repos.teams('user-name', 'repo-name') { |team| ... }
    #
    def teams(user_name=nil, repo_name=nil)
      _validate_user_repo_params(user_name, repo_name) unless user? && repo?
      _update_user_repo_params(user_name, repo_name)      

      response = get("/repos/#{user}/#{repo}/teams")
      return response unless block_given?
      response.each { |el| yield el }
    end
  
  end # Repos
end # Github
