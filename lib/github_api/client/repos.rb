# encoding: utf-8

module Github
  class Client::Repos < API
    # Load all the modules after initializing Repos to avoid superclass mismatch
    require_all 'github_api/client/repos',
      'collaborators',
      'comments',
      'commits',
      'contents',
      'deployments',
      'downloads',
      'forks',
      'hooks',
      'keys',
      'merging',
      'pages',
      'pub_sub_hubbub',
      'releases',
      'statistics',
      'statuses'

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
    namespace :collaborators

    # Access to Repos::Comments API
    namespace :comments

    # Access to Repos::Commits API
    namespace :commits

    # Access to Repos::Contents API
    namespace :contents

    # Access to Repos::Deployments API
    namespace :deployments

    # Access to Repos::Downloads API
    namespace :downloads

    # Access to Repos::Forks API
    namespace :forks

    # Access to Repos::Hooks API
    namespace :hooks

    # Access to Repos::Keys API
    namespace :keys

    # Access to Repos::Merging API
    namespace :merging

    # Access to Repos::Pages API
    namespace :pages

    # Access to Repos::PubSubHubbub API
    namespace :pubsubhubbub, full_name: :pub_sub_hubbub

    # Access to Repos::Releases API
    namespace :releases

    # Access to Repos::Statistics API
    namespace :stats, full_name: :statistics

    # Access to Repos::Statuses API
    namespace :statuses

    # List repositories for the authenticated user
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.repos.list
    #   github.repos.list { |repo| ... }
    #
    # List all repositories
    #
    # This provides a dump of every repository,
    # in the order that they were created.
    #
    # @param [Hash] params
    # @option params [Integer] :since
    #   the integer ID of the last Repository that you've seen.
    #
    # @example
    #   github = Github.new
    #   github.repos.list :every
    #   github.repos.list :every { |repo| ... }
    #
    # List public repositories for the specified user.
    #
    # @example
    #   github = Github.new
    #   github.repos.list user: 'user-name'
    #   github.repos.list user: 'user-name', { |repo| ... }
    #
    # List repositories for the specified organisation.
    #
    # @example
    #  github = Github.new
    #  github.repos.list org: 'org-name'
    #  github.repos.list org: 'org-name', { |repo| ... }
    #
    # @api public
    def list(*args)
      arguments(args) do
        permit %w[ user org type sort direction since ]
      end
      params = arguments.params

      response = if (user_name = params.delete('user') || user)
        get_request("/users/#{user_name}/repos", params)
      elsif (org_name = params.delete('org') || org)
        get_request("/orgs/#{org_name}/repos", params)
      elsif args.map(&:to_s).include?('every')
        get_request('/repositories', params)
      else
        # For authenticated user
        get_request('/user/repos', params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a repository
    #
    # @example
    #  github = Github.new
    #  github.repos.get 'user-name', 'repo-name'
    #  github.repos.get user: 'user-name', repo: 'repo-name'
    #  github.repos(user: 'user-name', repo: 'repo-name').get
    #
    def get(*args)
      arguments(args, required: [:user, :repo])

      get_request("/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
    alias :find :get

    # Create a new repository for the autheticated user.
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Required string
    # @option params [String] :description
    #   Optional string
    # @option params [String] :homepage
    #   Optional string
    # @option params [Boolean] :private
    #   Optional boolean - true to create a private  repository,
    #                      false to create a public one.
    # @option params [Boolean] :has_issues
    #   Optional boolean - true to enable issues  for this repository,
    #                      false to disable them
    # @option params [Boolean] :has_wiki
    #   Optional boolean - true to enable the wiki for this repository,
    #                      false to disable it. Default is true
    # @option params [Boolean] :has_downloads
    #   Optional boolean - true to enable downloads for this repository
    # @option params [String] :org
    #   Optional string - The organisation in which this
    #   repository will be created
    # @option params [Numeric] :team_id
    #   Optional number - The id of the team that will be granted
    #   access to this repository. This is only valid when creating
    #   a repo in an organization
    # @option params [Boolean] :auto_init
    #   Optional boolean - true to create an initial commit with
    #   empty README. Default is false.
    # @option params [String] :gitignore_template
    #   Optional string - Desired language or platform .gitignore
    #   template to apply. Use the name of the template without
    #   the extension. For example, “Haskell” Ignored if
    #   auto_init parameter is not provided.
    #
    # @example
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
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.repos.create name: 'repo-name', org: 'organisation-name'
    #
    # @example
    def create(*args)
      arguments(args) do
        permit VALID_REPO_OPTIONS + %w[ org ]
        assert_required %w[ name ]
      end
      params = arguments.params

      # Requires authenticated user
      if (org = params.delete('org') || org)
        post_request("/orgs/#{org}/repos", params.merge_default(DEFAULT_REPO_OPTIONS))
      else
        post_request('/user/repos', params.merge_default(DEFAULT_REPO_OPTIONS))
      end
    end

    # Delete a repository
    #
    # Deleting a repository requires admin access.
    # If OAuth is used, the delete_repo scope is required.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.repos.delete 'user-name', 'repo-name'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
    alias :remove :delete

    # List contributors
    #
    # @param [Hash] params
    # @option params [Boolean] :anon
    #   Optional flag. Set to 1 or true to include anonymous contributors.
    #
    # @examples
    #  github = Github.new
    #  github.repos.contributors 'user-name','repo-name'
    #  github.repos.contributors 'user-name','repo-name' { |cont| ... }
    #
    # @api public
    def contributors(*args)
      arguments(args, required: [:user, :repo]) do
        permit %w[ anon ]
      end
      params = arguments.params

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/contributors", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_contributors :contributors
    alias :contribs :contributors

    # Edit a repository
    #
    # @param [Hash] params
    # @option params [String] :name
    #   Required string
    # @option params [String] :description
    #   Optional string
    # @option params [String] :homepage
    #   Optional string
    # @option params [Boolean] :private
    #   Optional boolean, true to make this a private repository, false to make it a public one
    # @option params [Boolean] :has_issues
    #   Optional boolean - true to enable issues for this repository,
    #   false to disable them
    # @option params [Boolean] :has_wiki
    #   Optional boolean - true to enable the wiki for this repository,
    #   false to disable it. Default is true
    # @option params [Boolean] :has_downloads
    #   Optional boolean - true to enable downloads for this repository
    # @option params [String] :default_branch
    #   Optional string - Update the default branch for this repository.
    #
    # @example
    #  github = Github.new
    #  github.repos.edit 'user-name', 'repo-name',
    #    name: 'hello-world',
    #    description: 'This is your first repo',
    #    homepage: "https://github.com",
    #    public: true, has_issues: true
    #
    def edit(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_REPO_OPTIONS
        assert_required %w[ name ]
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}", arguments.params.merge_default(DEFAULT_REPO_OPTIONS))
    end

    # Delete a repository
    #
    # Deleting a repository requires admin access.
    # If OAuth is used, the delete_repo scope is required.
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.repos.delete 'user-name', 'repo-name'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params

      delete_request("/repos/#{arguments.user}/#{arguments.repo}", arguments.params)
    end
    alias :remove :delete

    # List branches
    #
    # @example
    #   github = Github.new
    #   github.repos.branches 'user-name', 'repo-name'
    #   github.repos(user: 'user-name', repo: 'repo-name').branches
    #
    # @example
    #   repos = Github::Repos.new
    #   repos.branches 'user-name', 'repo-name'
    #
    # @api public
    def branches(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/branches", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_branches :branches

    # Get branch
    #
    # @example
    #   github = Github.new
    #   github.repos.branch 'user-name', 'repo-name', 'branch-name'
    #   github.repos.branch user: 'user-name', repo: 'repo-name', branch: 'branch-name'
    #   github.repos(user: 'user-name', repo: 'repo-name', branch: 'branch-name').branch
    # @api public
    def branch(*args)
      arguments(args, required: [:user, :repo, :branch])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/branches/#{arguments.branch}", arguments.params)
    end

    # List contributors
    #
    # @param [Hash] params
    # @option params [Boolean] :anon
    #   Optional flag. Set to 1 or true to include anonymous contributors.
    #
    # @example
    #  github = Github.new
    #  github.repos.contributors 'user-name','repo-name'
    #  github.repos.contributors 'user-name','repo-name' { |cont| ... }
    #
    # @api public
    def contributors(*args)
      arguments(args, required: [:user, :repo]) do
        permit ['anon']
      end

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/contributors", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_contributors :contributors
    alias :contribs :contributors

    # List languages
    #
    # @examples
    #  github = Github.new
    #  github.repos.languages 'user-name', 'repo-name'
    #  github.repos.languages 'user-name', 'repo-name' { |lang| ... }
    #
    # @api public
    def languages(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/languages", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_languages :languages

    # List tags
    #
    # @example
    #   github = Github.new
    #   github.repos.tags 'user-name', 'repo-name'
    #   github.repos.tags 'user-name', 'repo-name' { |tag| ... }
    #
    # @api public
    def tags(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/tags", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_tags :tags
    alias :repo_tags :tags
    alias :repository_tags :tags

    # List teams
    #
    # @example
    #   github = Github.new
    #   github.repos.teams 'user-name', 'repo-name'
    #   github.repos.teams 'user-name', 'repo-name' { |team| ... }
    #
    # @example
    #   github.repos(user: 'user-name, repo: 'repo-name').teams
    #
    # @api public
    def teams(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/teams", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_teams :teams
    alias :repo_teams :teams
    alias :repository_teams :teams
  end # Client::Repos
end # Github
