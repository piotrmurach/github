# encoding: utf-8

module Github
  class Users::Keys < API

    VALID_KEY_PARAM_NAMES = %w[ title key ].freeze

    # List public keys for the authenticated user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.keys.list
    #  github.users.keys.list { |key| ... }
    #
    def list(*args)
      arguments(args)
      response = get_request("/user/keys", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    alias :all :list

    # Get a single pulic key for the authenticated user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.keys.get 'key-id'
    #
    def get(*args)
      arguments(args, :required => [:key_id])
      get_request("/user/keys/#{key_id}", arguments.params)
    end

    alias :find :get


    # Get all keys for a specified user
    #
    # = Examples
    #  github = Github.new
    #  github.users.keys.list_for_user user: 'user-name'
    #
    def list_for_user(*args)
      arguments(args, :required => [:user])
      response = get_request("/users/#{user}/keys", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end


    # Create a public key for the authenticated user
    #
    # = Inputs
    # * <tt>:title</tt> - Required string
    # * <tt>:key</tt> - Required string. sha key
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.keys.create "title": "octocat@octomac", "key": "ssh-rsa AAA..."
    #
    def create(*args)
      arguments(args) do
        sift VALID_KEY_PARAM_NAMES
      end
      post_request("/user/keys", arguments.params)
    end

    # Update a public key for the authenticated user
    #
    # = Inputs
    # * <tt>:title</tt> - Required string
    # * <tt>:key</tt> - Required string. sha key
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.keys.update 'key-id', "title": "octocat@octomac",
    #    "key": "ssh-rsa AAA..."
    #
    def update(*args)
      arguments(args, :required => [:key_id]) do
        sift VALID_KEY_PARAM_NAMES
      end
      patch_request("/user/keys/#{key_id}", arguments.params)
    end

    # Delete a public key for the authenticated user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.keys.delete 'key-id'
    #
    def delete(*args)
      arguments(args, :required => [:key_id])
      delete_request("/user/keys/#{key_id}", arguments.params)
    end

  end # Users::Keys
end # Github
