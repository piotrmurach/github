# encoding: utf-8

module Github
  class Repos < API
    extend AutoloadHelper

    # Load all the modules after initializing Repos to avoid superclass mismatch
    autoload_all 'github_api/repos',
      :Collaborators => 'collaborators',
      :Comments      => 'comments',
      :Commits       => 'commits',
      :Contents      => 'contents',
      :Downloads     => 'downloads',
      :Forks         => 'forks',
      :Hooks         => 'hooks',
      :Keys          => 'keys',
      :Merging       => 'merging',
      :PubSubHubbub  => 'pub_sub_hubbub',
      :Statistics    => 'statistics',
      :Statuses      => 'statuses'

    DEFAULT_REPO_OPTIONS = {
      "homepage"   => "https://github.com",
      "private"    => false,
      "has_issues" => true,
      "has_wiki"   => true,
      "has_downloads" => true
    }.freeze

    REQUIRED_REPO_OPTIONS = %w[ name ]

    VALID_REPO_OPTIONS = %w[
      name
      description
      homepage
      private
      has_issues
      has_wiki
      has_downloads
      team_id
      auto_init
      gitignore_template
      default_branch
    ].freeze

    VALID_REPO_TYPES = %w[ all public private member ].freeze

    # Access to Repos::Collaborators API
    def collaborators(options={}, &block)
      @collaborators ||= ApiFactory.new('Repos::Collaborators', current_options.merge(options), &block)
    end

    # Access to Repos::Comments API
    def comments(options={}, &block)
      @commits ||= ApiFactory.new('Repos::Comments', current_options.merge(options), &block)
    end

    # Access to Repos::Commits API
    def commits(options={}, &block)
      @commits ||= ApiFactory.new('Repos::Commits', current_options.merge(options), &block)
    end

    # Access to Repos::Contents API
    def contents(options={}, &block)
      @contents ||= ApiFactory.new('Repos::Contents', current_options.merge(options), &block)
    end

    # Access to Repos::Downloads API
    def downloads(options={}, &block)
      @downloads ||= ApiFactory.new('Repos::Downloads', current_options.merge(options), &block)
    end

    # Access to Repos::Forks API
    def forks(options={}, &block)
      @forks ||= ApiFactory.new('Repos::Forks', current_options.merge(options), &block)
    end

    # Access to Repos::Hooks API
    def hooks(options={}, &block)
      @hooks ||= ApiFactory.new('Repos::Hooks', current_options.merge(options), &block)
    end

    # Access to Repos::Keys API
    def keys(options={}, &block)
      @keys ||= ApiFactory.new('Repos::Keys', current_options.merge(options), &block)
    end

    # Access to Repos::Merging API
    def merging(options={}, &block)
      @mergin ||= ApiFactory.new('Repos::Merging', current_options.merge(options), &block)
    end

    # Access to Repos::PubSubHubbub API
    def pubsubhubbub(options={}, &block)
      @pubsubhubbub ||= ApiFactory.new('Repos::PubSubHubbub', current_options.merge(options), &block)
    end

    # Access to Repos::Statistics API
    def stats(options={}, &block)
      @stats ||= ApiFactory.new('Repos::Statistics', current_options.merge(options), &block)
    end

    # Access to Repos::Statuses API
    def statuses(options={}, &block)
      @statuses ||= ApiFactory.new('Repos::Statuses', current_options.merge(options), &block)
    end

    # List repositories for the authenticated user
    #
    # = Examples
    #   github = Github.new :oauth_token => '...'
    #   github.repos.list
    #   github.repos.list { |repo| ... }
    #
    # List all repositories
    #
    # This provides a dump of every repository, in the order that they were created.
    # = Parameters
    # * <tt>:since</tt> - the integer ID of the last Repository that you've seen.
    #
    # = Examples
    #   github = Github.new
    #   github.repos.list every: true
    #   github.repos.list every: true { |repo| ... }
    #
    # List public repositories for the specified user.
    #
    # = Examples
    #   github = Github.new
    #   github.repos.list user: 'user-name'
    #   github.repos.list user: 'user-name', { |repo| ... }
    #
    # List repositories for the specified organisation.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.list org: 'org-name'
    #  github.repos.list org: 'org-name', { |repo| ... }
    #
    def list(*args)
      arguments(args) do
        sift %w[ user org type sort direction since ]
      end
      params = arguments.params

      response = if (user_name = (params.delete("user")))
        get_request("/users/#{user_name}/repos", params)
      elsif (org_name = (params.delete("org")))
        get_request("/orgs/#{org_name}/repos", params)
      elsif args.map(&:to_s).include?("every")
        get_request("/repositories", params)
      else
        # For authenticated user
        get_request("/user/repos", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a repository
    #
    # = Examples
    #  github = Github.new
    #  github.repos.get 'user-name', 'repo-name'
    #  github.repos.get user: 'user-name', repo: 'repo-name'
    #  github.repos(user: 'user-name', repo: 'repo-name').get
    #
    def get(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}", params)
    end
    alias :find :get

    # Create a new repository for the autheticated user.
    #
    # = Parameters
    #  <tt>:name</tt> - Required string
    #  <tt>:description</tt> - Optional string
    #  <tt>:homepage</tt> - Optional string
    #  <tt>:private</tt> - Optional boolean - <tt>true</tt> to create a private repository, <tt>false</tt> to create a public one.
    #  <tt>:has_issues</tt> - Optional boolean - <tt>true</tt> to enable issues for this repository, <tt>false</tt> to disable them
    #  <tt>:has_wiki</tt> - Optional boolean - <tt>true</tt> to enable the wiki for this repository, <tt>false</tt> to disable it. Default is <tt>true</tt>
    #  <tt>:has_downloads</tt> Optional boolean - <tt>true</tt> to enable downloads for this repository
    #  <tt>:org</tt> Optional string - The organisation in which this repository will be created
    #  <tt>:team_id</tt> Optional number - The id of the team that will be granted access to this repository. This is only valid when creating a repo in an organization
    #  <tt>:auto_init</tt> Optional boolean - true to create an initial commit with empty README. Default is false.
    #  <tt>:gitignore_template</tt> Optional string - Desired language or platform .gitignore template to apply. Use the name of the template without the extension. For example, “Haskell” Ignored if auto_init parameter is not provided.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.create "name": 'repo-name'
    #    "description": "This is your first repo",
    #    "homepage": "https://github.com",
    #    "private": false,
    #    "has_issues": true,
    #    "has_wiki": true,
    #    "has_downloads": true
    #
    # Create a new repository in this organisation. The authenticated user
    # must be a member of this organisation
    #
    # Examples:
    #   github = Github.new :oauth_token => '...'
    #   github.repos.create :name => 'repo-name', :org => 'organisation-name'
    #
    def create(*args)
      arguments(args) do
        sift VALID_REPO_OPTIONS + %w[ org ]
        assert_required %w[ name ]
      end
      params = arguments.params

      # Requires authenticated user
      if (org = params.delete("org"))
        post_request("/orgs/#{org}/repos", params.merge_default(DEFAULT_REPO_OPTIONS))
      else
        post_request("/user/repos", params.merge_default(DEFAULT_REPO_OPTIONS))
      end
    end

    # Delete a repository
    #
    # Deleting a repository requires admin access.
    # If OAuth is used, the delete_repo scope is required.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.repos.delete 'user-name', 'repo-name'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}", params)
    end
    alias :remove :delete

    # List contributors
    #
    # = Parameters
    #  <tt>:anon</tt> - Optional flag. Set to 1 or true to include anonymous contributors.
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.contributors 'user-name','repo-name'
    #  github.repos.contributors 'user-name','repo-name' { |cont| ... }
    #
    def contributors(*args)
      arguments(args, :required => [:user, :repo]) do
        sift %w[ anon ]
      end
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/contributors", params)
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
    #  <tt>:private</tt> - Optional boolean - <tt>false</tt> to create public reps, <tt>false</tt> to create a private one
    # * <tt>:has_issues</tt>    Optional boolean - <tt>true</tt> to enable issues for this repository, <tt>false</tt> to disable them
    # * <tt>:has_wiki</tt>      Optional boolean - <tt>true</tt> to enable the wiki for this repository, <tt>false</tt> to disable it. Default is <tt>true</tt>
    # * <tt>:has_downloads</tt> Optional boolean - <tt>true</tt> to enable downloads for this repository
    # * <tt>:default_branch</tt> Optional string - Update the default branch for this repository.
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.edit 'user-name', 'repo-name',
    #    :name => 'hello-world',
    #    :description => 'This is your first repo',
    #    :homepage => "https://github.com",
    #    :public => true, :has_issues => true
    #
    def edit(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_REPO_OPTIONS
        assert_required %w[ name ]
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}", params.merge_default(DEFAULT_REPO_OPTIONS))
    end

    # Delete a repository
    #
    # Deleting a repository requires admin access.
    # If OAuth is used, the delete_repo scope is required.
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.repos.delete 'user-name', 'repo-name'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}", params)
    end
    alias :remove :delete

    # List branches
    #
    # = Examples
    #
    #   github = Github.new
    #   github.repos.branches 'user-name', 'repo-name'
    #   github.repos(user: 'user-name', repo: 'repo-name').branches
    #
    #   repos = Github::Repos.new
    #   repos.branches 'user-name', 'repo-name'
    #
    # def branches(user_name, repo_name, params={})
    def branches(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/branches", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_branches :branches

    # Get branch
    #
    # = Examples
    #
    #   github = Github.new
    #   github.repos.branch 'user-name', 'repo-name', 'branch-name'
    #   github.repos.branch user: 'user-name', repo: 'repo-name', branch: 'branch-name'
    #   github.repos(user: 'user-name', repo: 'repo-name', branch: 'branch-name').branch
    #
    def branch(*args)
      arguments(args, :required => [:user, :repo, :branch])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/branches/#{branch}", params)
    end

    # List contributors
    #
    # = Parameters
    #  <tt>:anon</tt> - Optional flag. Set to 1 or true to include anonymous contributors.
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.contributors 'user-name','repo-name'
    #  github.repos.contributors 'user-name','repo-name' { |cont| ... }
    #
    def contributors(*args)
      arguments(args, :required => [:user, :repo]) do
        sift ['anon']
      end
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/contributors", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_contributors :contributors
    alias :contribs :contributors

    # List languages
    #
    # = Examples
    #  github = Github.new
    #  github.repos.languages 'user-name', 'repo-name'
    #  github.repos.languages 'user-name', 'repo-name' { |lang| ... }
    #
    def languages(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/languages", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_languages :languages

    # List tags
    #
    # = Examples
    #   github = Github.new
    #   github.repos.tags 'user-name', 'repo-name'
    #   github.repos.tags 'user-name', 'repo-name' { |tag| ... }
    #
    def tags(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/tags", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_tags :tags
    alias :repo_tags :tags
    alias :repository_tags :tags

    # List teams
    #
    # == Examples
    #   github = Github.new
    #   github.repos.teams 'user-name', 'repo-name'
    #   github.repos.teams 'user-name', 'repo-name' { |team| ... }
    #
    #   github.repos(user: 'user-name, repo: 'repo-name').teams
    #
    def teams(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/teams", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_teams :teams
    alias :repo_teams :teams
    alias :repository_teams :teams

  end # Repos
end # Github
