# encoding: utf-8

module Github
  class Users
    module Keys

      VALID_KEY_PARAM_NAMES = %w[ title key ].freeze

      # List public keys for the authenticated user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.public_keys
      #  @github.users.public_keys { |key| ... }
      #
      def keys(params={})
        _normalize_params_keys(params)
        response = get("/user/keys", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :public_keys :keys

      # Get a single pulic key for the authenticated user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.public_key 'key-id'
      #
      def key(key_id, params={})
        _validate_presence_of key_id
        _normalize_params_keys(params)
        get("/user/keys/#{key_id}", params)
      end
      alias :public_key :key

      # Create a public key for the authenticated user
      #
      # = Inputs
      # * <tt>:title</tt> - Required string
      # * <tt>:key</tt> - Required string. sha key
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.create_key "title" => "octocat@octomac",
      #    "key" => "ssh-rsa AAA..."
      #
      def create_key(params={})
        _normalize_params_keys(params)
        _filter_params_keys(VALID_KEY_PARAM_NAMES, params)
        post("/user/keys", params)
      end

      # Update a public key for the authenticated user
      #
      # = Inputs
      # * <tt>:title</tt> - Required string
      # * <tt>:key</tt> - Required string. sha key
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.update_key 'key-id', "title" => "octocat@octomac",
      #    "key" => "ssh-rsa AAA..."
      #
      def update_key(key_id, params={})
        _validate_presence_of key_id
        _normalize_params_keys(params)
        _filter_params_keys(VALID_KEY_PARAM_NAMES, params)
        patch("/user/keys/#{key_id}", params)
      end

      # Delete a public key for the authenticated user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.delete_key 'key-id'
      #
      def delete_key(key_id, params={})
        _validate_presence_of key_id
        _normalize_params_keys(params)
        delete("/user/keys/#{key_id}", params)
      end

    end # Keys
  end # Users
end # Github
