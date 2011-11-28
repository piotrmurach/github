# encoding: utf-8

module Github
  class Gists < API
    extend AutoloadHelper

    autoload_all 'github_api/gists',
      :Comments => 'comments'

    include Github::Gists::Comments

    REQUIRED_GIST_INPUTS = %w[ description public files content ]

    # Creates new Gists API
    def initialize(options = {})
      super(options)
    end

    # List a user's gists.
    #
    # = Examples
    #  @github = Github.new :user => 'user-name'
    #  @github.gists.gists
    #
    # List the authenticated user’s gists or if called anonymously, 
    # this will returns all public gists
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.gists.gists
    #
    def gists(user_name=nil, params={})
      _update_user_repo_params(user_name)
      _normalize_params_keys(params)

      response = if user
        get("/users/#{user}/gists", params)
      elsif oauth_token
        get("/gists", params)
      else
        get("/gists/public", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_gists :gists

    # List the authenticated user's starred gists
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.gists.starred
    #
    def starred(params={})
      _normalize_params_keys(params)
      get("/gists/starred", params)
    end

    # Get a single gist
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.gists.get_gist 'gist-id'
    #
    def get_gist(gist_id, params={})
      _normalize_params_keys(params)
      get("/gists/#{gist_id}", params)
    end

    # Create a gist
    #
    # = Inputs
    #  <tt>:description</tt> - Optional string
    #  <tt>:public</tt>  - Required boolean
    #  <tt>:files</tt> - Required hash - Files that make up this gist.
    #     The key of which should be a required string filename and 
    #     the value another required hash with parameters:
    #        <tt>:content</tt> - Required string - File contents.
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.gists.create_gist 
    #    'description' => 'the description for this gist',
    #    'public' => true,
    #    'files' => {
    #      'file1.txt' => {
    #         'content' => 'String file contents'
    #       }
    #    }
    #
    def create_gist(params={})
      _normalize_params_keys(params)
      _filter_params_keys(REQUIRED_GIST_INPUTS, params)

      post("/gists", params)
    end

    # Edit a gist
    #
    # = Inputs
    #  <tt>:description</tt> - Optional string
    #  <tt>:files</tt> - Optional hash - Files that make up this gist.
    #     The key of which should be a optional string filename and 
    #     the value another optional hash with parameters:
    #        <tt>:content</tt> - Updated string - Update file contents.
    #        <tt>:filename</tt> - Optional string - New name for this file.
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.gists.edit_gist 'gist-id', 
    #    'description' => 'the description for this gist',
    #    'files' => {
    #      'file1.txt' => {
    #         'content' => 'Updated file contents'
    #       },
    #      'old_name.txt' => {
    #         'filename' => 'new_name.txt',
    #         'content' => 'modified contents'
    #       },
    #      'new_file.txt' => {
    #         'content' => 'a new file contents'
    #       },
    #       'delete_the_file.txt' => nil
    #    }
    #
    def edit_gist(gist_id, params={})
      _validate_presence_of(gist_id)
      _normalize_params_keys(params)
      _filter_params_keys(REQUIRED_GIST_INPUTS, params)

      patch("/gists/#{gist_id}", params)
    end

    # Star a gist
    #
    # = Examples
    #  @github = Github.new
    #  @github.gists.star 'gist-id'
    #
    def star(gist_id, params={})
      _validate_presence_of(gist_id)
      _normalize_params_keys(params)

      put("/gists/#{gist_id}/star", params)
    end

    # Unstar a gist
    #
    # = Examples
    #  @github = Github.new
    #  @github.gists.unstar 'gist-id'
    #
    def unstar_gist(gist_id, params={})
      _validate_presence_of(gist_id)
      _normalize_params_keys(params)

      delete("/gists/#{gist_id}/star", params)
    end

    # Check if a gist is starred 
    #
    # = Examples
    #  @github = Github.new
    #  @github.gists.unstar 'gist-id'
    #
    def starred?(gist_id, params={})
      _validate_presence_of(gist_id)
      _normalize_params_keys(params)

      get("/gists/#{gist_id}/star", params)
    end

    # Fork a gist
    #
    # = Examples
    #  @github = Github.new
    #  @github.gists.fork 'gist-id'
    #
    def fork(gist_id, params={})
      _validate_presence_of(gist_id)
      _normalize_params_keys(params)

      post("/gists/#{gist_id}/fork", params)
    end

    # Delete a gist
    #
    # = Examples
    #  @github = Github.new
    #  @github.gists.delete_gist 'gist-id'
    #
    def delete_gist(gist_id, params={})
      _validate_presence_of(gist_id)
      _normalize_params_keys(params)

      delete("/gists/#{gist_id}", params)
    end

  end # Gists
end # Github
