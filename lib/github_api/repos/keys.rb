# encoding: utf-8

module Github
  class Repos
    module Keys

      VALID_KEY_PARAM_NAMES = %w[ title key ].freeze

      # List deploy keys
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.keys 'user-name', 'repo-name'
      #  @github.repos.keys 'user-name', 'repo-name' { |key| ... }
      #
      def keys(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/keys", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Get a key
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.get_key 'user-name', 'repo-name', 'key-id'
      #
      def get_key(user_name, repo_name, key_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of key_id
        _normalize_params_keys(params)

        get("/repos/#{user}/#{repo}/keys/#{key_id}", params)
      end

      # Create a key
      #
      # = Inputs
      # * <tt>:title</tt> - Required string.
      # * <tt>:key</tt> - Required string.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.create_key 'user-name', 'repo-name',
      #    "title" => "octocat@octomac",
      #    "key" =>  "ssh-rsa AAA..."
      #
      def create_key(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)
        _filter_params_keys(VALID_KEY_PARAM_NAMES, params)

        raise ArgumentError, "Required params are: #{VALID_KEY_PARAM_NAMES.join(', ')}" unless _validate_inputs(VALID_KEY_PARAM_NAMES, params)

        post("/repos/#{user}/#{repo}/keys", params)
      end

      # Edit a key
      #
      # = Inputs
      # * <tt>:title</tt> - Required string.
      # * <tt>:key</tt> - Required string.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.create_key 'user-name', 'repo-name',
      #    "title" => "octocat@octomac",
      #    "key" =>  "ssh-rsa AAA..."
      #
      def edit_key(user_name, repo_name, key_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of key_id

        _normalize_params_keys(params)
        _filter_params_keys(VALID_KEY_PARAM_NAMES, params)

        patch("/repos/#{user}/#{repo}/keys/#{key_id}", params)
      end

      # Delete key
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.delete_key 'user-name', 'repo-name', 'key-id'
      #
      def delete_key(user_name, repo_name, key_id, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of key_id
        _normalize_params_keys(params)

        delete("/repos/#{user}/#{repo}/keys/#{key_id}", params)
      end

    end # Keys
  end # Repos
end # Github
