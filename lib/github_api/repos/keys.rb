# encoding: utf-8

module Github
  class Repos::Keys < API

    VALID_KEY_PARAM_NAMES = %w[ title key ].freeze

    # List deploy keys
    #
    # = Examples
    #  github = Github.new
    #  github.repos.keys.list 'user-name', 'repo-name'
    #  github.repos.keys.list 'user-name', 'repo-name' { |key| ... }
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/repos/#{user}/#{repo}/keys", params)
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
    def get(user_name, repo_name, key_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of key_id
      normalize! params

      get_request("/repos/#{user}/#{repo}/keys/#{key_id}", params)
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
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params
      filter! VALID_KEY_PARAM_NAMES, params
      assert_required_keys(VALID_KEY_PARAM_NAMES, params)

      post_request("/repos/#{user}/#{repo}/keys", params)
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
    def edit(user_name, repo_name, key_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of key_id

      normalize! params
      filter! VALID_KEY_PARAM_NAMES, params

      patch_request("/repos/#{user}/#{repo}/keys/#{key_id}", params)
    end

    # Delete key
    #
    # = Examples
    #  @github = Github.new
    #  @github.repos.keys.delete 'user-name', 'repo-name', 'key-id'
    #
    def delete(user_name, repo_name, key_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of key_id
      normalize! params

      delete_request("/repos/#{user}/#{repo}/keys/#{key_id}", params)
    end

  end # Repos::Keys
end # Github
