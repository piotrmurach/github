# encoding: utf-8

module Github
  class Repos < API
    extend AutoloadHelper

    # Load all the modules after initializing Repos to avoid superclass mismatch
    autoload_all 'github_api/repos',
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

    VALID_REPO_OPTIONS = %w[
      name
      description
      homepage
      public
      has_issues
      has_wiki
      has_downloads
    ].freeze

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
    #   @github.repos.branches 'user-name', 'repo-name'
    #
    #   @repos = Github::Repos.new
    #   @repos.branches 'user-name', 'repo-name'
    #
    def branches(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless (user? && repo?)
      _normalize_params_keys(params)

      response = get("/repos/#{user}/#{repo}/branches", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_branches :branches

    # Create a new repository for the autheticated user.
    #
    # = Parameters
    #  <tt>:name</tt> - Required string
    #  <tt>:description</tt> - Optional string
    #  <tt>:homepage</tt> - Optional string
    #  <tt>:public</tt> - Optional boolean - true to create public repo, false to create a private one
    #  <tt>:has_issues</tt> - Optional boolean - <tt>true</tt> to enable issues for this repository, <tt>false</tt> to disable them
    #  <tt>:has_wiki</tt> - Optional boolean - <tt>true</tt> to enable the wiki for this repository, <tt>false</tt> to disable it. Default is <tt>true</tt>
    #  <tt>:has_downloads</tt> Optional boolean - <tt>true</tt> to enable downloads for this repository
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.create_repo :name => 'my_repo_name'
    #
    # Create a new repository in this organisation. The authenticated user 
    # must be a member of this organisation
    #
    # Examples:
    #   @github = Github.new :oauth_token => '...'
    #   @github.repos.create_repo(:name => 'my-repo-name', :org => 'my-organisation')
    #
    def create_repo(*args)
      params = args.last.is_a?(Hash) ? args.pop : {}
      _normalize_params_keys(params)
      _filter_params_keys(VALID_REPO_OPTIONS + %w[ org ], params)

      raise ArgumentError, "Required params are: :name" unless _validate_inputs(%w[ name ], params)

      # Requires authenticated user
      if (org = params.delete("org"))
        post("/orgs/#{org}/repos", DEFAULT_REPO_OPTIONS.merge(params))
      else
        post("/user/repos", DEFAULT_REPO_OPTIONS.merge(params))
      end
    end
    alias :create_repository :create_repo

    # List contributors
    #
    # = Parameters
    #  <tt>:anon</tt> - Optional flag. Set to 1 or true to include anonymous contributors.
    #
    # = Examples
    #
    #  @github = Github.new
    #  @github.repos.contributors('user-name','repo-name')
    #  @github.repos.contributors('user-name','repo-name') { |cont| ... }
    #
    def contributors(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)
      _filter_params_keys(['anon'], params)

      response = get("/repos/#{user}/#{repo}/contributors", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_contributors :contributors
    alias :contribs :contributors

    # Edit a repository
    #
    # = Parameters
    # * <tt>:name</tt> Required string
    # * <tt>:description</tt>   Optional string
    # * <tt>:homepage</tt>      Optional string
    # * <tt>:public</tt>        Optional boolean - true to create public repo, false to create a private one
    # * <tt>:has_issues</tt>    Optional boolean - <tt>true</tt> to enable issues for this repository, <tt>false</tt> to disable them
    # * <tt>:has_wiki</tt>      Optional boolean - <tt>true</tt> to enable the wiki for this repository, <tt>false</tt> to disable it. Default is <tt>true</tt>
    # * <tt>:has_downloads</tt> Optional boolean - <tt>true</tt> to enable downloads for this repository
    #
    # = Examples
    #
    #  @github = Github.new
    #  @github.repos.edit_repo('user-name', 'repo-name', { :name => 'hello-world', :description => 'This is your first repo', :homepage => "https://github.com", :public => true, :has_issues => true })
    #
    def edit_repo(user=nil, repo=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _normalize_params_keys(params)
      _filter_params_keys(VALID_REPO_OPTIONS, params)

      raise ArgumentError, "Required params are: #{%w[ :name ] }" unless _validate_inputs(%w[ name ], params)

      patch("/repos/#{user}/#{repo}", DEFAULT_REPO_OPTIONS.merge(params))
    end
    alias :edit_repository :edit_repo

    # Get a repository
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.get_repo('user-name', 'repo-name')
    #
    def get_repo(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)

      get("/repos/#{user}/#{repo}", params)
    end
    alias :get_repository :get_repo


    # List languages
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.languages('user-name', 'repo-name')
    #  @github.repos.languages('user-name', 'repo-name') { |lang| ... }
    #
    def languages(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)

      response = get("/repos/#{user}/#{repo}/languages", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_languages :languages

    # List repositories for the authenticated user
    #
    # = Examples
    #   @github = Github.new { :consumer_key => ... }
    #   @github.repos.list_repos
    #
    # List public repositories for the specified user.
    #
    # = Examples
    #   github = Github.new
    #   github.repos.list_repos(:user => 'user-name')
    #
    # List repositories for the specified organisation.
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.list_repos(:org => 'org-name')
    #
    def repos(*args)
      params = args.last.is_a?(Hash) ? args.pop : {}
      _normalize_params_keys(params)
      _merge_user_into_params!(params) unless params.has_key?('user')
      _filter_params_keys(%w[ org user type ], params)

      if (user_name = params.delete("user"))
        get("/users/#{user_name}/repos")
      elsif (org_name = params.delete("org"))
        get("/users/#{org_name}/repos", params)
      else
        # For authenticated user
        get("/user/repos", params)
      end
    end
    alias :list_repos :repos
    alias :list_repositories :repos

    # List tags
    #
    # = Examples
    #   @github = Github.new
    #   @github.repos.tags('user-name', 'repo-name')
    #   @github.repos.tags('user-name', 'repo-name') { |tag| ... }
    #
    def tags(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)

      response = get("/repos/#{user}/#{repo}/tags", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :repo_tags :tags
    alias :repository_tags :tags

    # List teams
    #
    # == Examples
    #   @github = Github.new
    #   @github.repos.teams('user-name', 'repo-name')
    #   @github.repos.teams('user-name', 'repo-name') { |team| ... }
    #
    def teams(user_name=nil, repo_name=nil, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _normalize_params_keys(params)

      response = get("/repos/#{user}/#{repo}/teams", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :repo_teams :teams
    alias :repository_teams :teams

  end # Repos
end # Github
