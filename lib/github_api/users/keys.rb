# encoding: utf-8

module Github
  class Users::Keys < API

    VALID_KEY_PARAM_NAMES = %w[ title key ].freeze

    # List public keys for the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.list
    #  github.users.followers.list { |key| ... }
    #
    def list(params={})
      normalize! params
      response = get_request("/user/keys", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single pulic key for the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.get 'key-id'
    #
    def get(key_id, params={})
      _validate_presence_of key_id
      normalize! params
      get_request("/user/keys/#{key_id}", params)
    end
    alias :find :get

    # Create a public key for the authenticated user
    #
    # = Inputs
    # * <tt>:title</tt> - Required string
    # * <tt>:key</tt> - Required string. sha key
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.create "title" => "octocat@octomac",
    #    "key" => "ssh-rsa AAA..."
    #
    def create(params={})
      normalize! params
      filter! VALID_KEY_PARAM_NAMES, params
      post_request("/user/keys", params)
    end

    # Update a public key for the authenticated user
    #
    # = Inputs
    # * <tt>:title</tt> - Required string
    # * <tt>:key</tt> - Required string. sha key
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.update 'key-id', "title" => "octocat@octomac",
    #    "key" => "ssh-rsa AAA..."
    #
    def update(key_id, params={})
      _validate_presence_of key_id
      normalize! params
      filter! VALID_KEY_PARAM_NAMES, params
      patch_request("/user/keys/#{key_id}", params)
    end

    # Delete a public key for the authenticated user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.delete 'key-id'
    #
    def delete(key_id, params={})
      _validate_presence_of key_id
      normalize! params
      delete_request("/user/keys/#{key_id}", params)
    end

  end # Users::Keys
end # Github
