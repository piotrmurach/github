# encoding: utf-8

module Github
  class Repos::Keys < API

    VALID_KEY_OPTIONS = %w[ title key ].freeze

    # List deploy keys
    #
    # = Examples
    #  github = Github.new
    #  github.repos.keys.list 'user-name', 'repo-name'
    #  github.repos.keys.list 'user-name', 'repo-name' { |key| ... }
    #
    #  keys = Github::Repos::Keys.new user: 'user-name', repo: 'repo-name'
    #  keys.list
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/repos/#{user}/#{repo}/keys", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a key
    #
    # = Examples
    #  github = Github.new
    #  github.repos.keys.get 'user-name', 'repo-name', 'key-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :key_id])

      get_request("/repos/#{user}/#{repo}/keys/#{key_id}", arguments.params)
    end
    alias :find :get

    # Create a key
    #
    # = Inputs
    # * <tt>:title</tt> - Required string.
    # * <tt>:key</tt> - Required string.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.keys.create 'user-name', 'repo-name',
    #    "title" => "octocat@octomac",
    #    "key" =>  "ssh-rsa AAA..."
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_KEY_OPTIONS
        assert_required VALID_KEY_OPTIONS
      end

      post_request("/repos/#{user}/#{repo}/keys", arguments.params)
    end

    # Edit a key
    #
    # = Inputs
    # * <tt>:title</tt> - Required string.
    # * <tt>:key</tt> - Required string.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.keys.edit 'user-name', 'repo-name',
    #    "title" => "octocat@octomac",
    #    "key" =>  "ssh-rsa AAA..."
    #
    def edit(*args)
      arguments(args, :required => [:user, :repo, :key_id]) do
        sift VALID_KEY_OPTIONS
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}/keys/#{key_id}", params)
    end

    # Delete key
    #
    # = Examples
    #  github = Github.new
    #  github.repos.keys.delete 'user-name', 'repo-name', 'key-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :key_id])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/keys/#{key_id}", params)
    end

  end # Repos::Keys
end # Github
