# encoding: utf-8

module Github
  class Client::Repos::Keys < API
    # List deploy keys
    #
    # @see https://developer.github.com/v3/repos/keys/#list
    #
    # @param [String] :user
    # @param [String :repo
    #
    # @example
    #   github = Github.new
    #   github.repos.keys.list 'user-name', 'repo-name'
    #   github.repos.keys.list 'user-name', 'repo-name' { |key| ... }
    #
    # @example
    #   keys = Github::Repos::Keys.new user: 'user-name', repo: 'repo-name'
    #   keys.list
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/keys",
                             arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get a key
    #
    # @see https://developer.github.com/v3/repos/keys/#get
    #
    # @param [String] :user
    # @param [String] :repo
    # @param [Integer] :id
    #
    # @example
    #   github = Github.new
    #   github.repos.keys.get 'user-name', 'repo-name', 'key-id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :id])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/keys/#{arguments.id}", arguments.params)
    end
    alias_method :find, :get

    # Create a key
    #
    # @see https://developer.github.com/v3/repos/keys/#create
    #
    # @param [String] :user
    # @param [String] :repo
    # @param [Hash] params
    # @option params [String] :title
    #   Required string.
    # @option params [String] :key
    #   Required string.
    # @option params [String] :read_only
    #   If true, the key will only be able to read repository contents.
    #   Otherwise, the key will be able to read and write.
    #
    # @example
    #   github = Github.new
    #   github.repos.keys.create 'user-name', 'repo-name',
    #     title: "octocat@octomac",
    #     key:  "ssh-rsa AAA..."
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo])

      post_request("/repos/#{arguments.user}/#{arguments.repo}/keys",
                   arguments.params)
    end
    alias_method :add, :create

    # Delete key
    #
    # @see https://developer.github.com/v3/repos/keys/#delete
    #
    # @param [String] :user
    # @param [String] :repo
    # @param [Integer] :id
    #
    # @example
    #   github = Github.new
    #   github.repos.keys.delete 'user-name', 'repo-name', 'key-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :id])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/keys/#{arguments.id}", arguments.params)
    end
    alias_method :remove, :delete
  end # Client::Repos::Keys
end # Github
