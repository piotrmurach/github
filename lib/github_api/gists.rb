# encoding: utf-8

module Github
  class Gists < API
    extend AutoloadHelper

    autoload_all 'github_api/gists',
      :Comments => 'comments'

    REQUIRED_GIST_INPUTS = %w[
      description
      public
      files
      content
    ].freeze

    # Creates new Gists API
    def initialize(options = {})
      super(options)
    end

    # Access to Gists::Comments API
    def comments
      @comments ||= ApiFactory.new 'Gists::Comments'
    end

    # List a user's gists.
    #
    # = Examples
    #  github = Github.new
    #  github.gists.list user: 'user-name'
    #
    # List the authenticated user’s gists or if called anonymously,
    # this will returns all public gists
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.gists.list
    #
    def list(params={})
      normalize! params

      user = params.delete('user')

      response = if user
        get_request("/users/#{user}/gists", params)
      elsif oauth_token
        get_request("/gists", params)
      else
        get_request("/gists/public", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List the authenticated user's starred gists
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.gists.starred
    #
    def starred(params={})
      normalize! params

      response = get_request("/gists/starred", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get a single gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.get 'gist-id'
    #
    def get(gist_id, params={})
      normalize! params
      _validate_presence_of(gist_id)

      get_request("/gists/#{gist_id}", params)
    end
    alias :find :get

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
    #  github = Github.new
    #  github.gists.create
    #    'description' => 'the description for this gist',
    #    'public' => true,
    #    'files' => {
    #      'file1.txt' => {
    #         'content' => 'String file contents'
    #       }
    #    }
    #
    def create(params={})
      normalize! params
      assert_required_keys(REQUIRED_GIST_INPUTS, params)

      post_request("/gists", params)
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
    #  github = Github.new :oauth_token => '...'
    #  github.gists.edit 'gist-id',
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
    def edit(gist_id, params={})
      _validate_presence_of(gist_id)
      normalize! params

      patch_request("/gists/#{gist_id}", params)
    end

    # Star a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.star 'gist-id'
    #
    def star(gist_id, params={})
      _validate_presence_of(gist_id)
      normalize! params

      put_request("/gists/#{gist_id}/star", params)
    end

    # Unstar a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.unstar 'gist-id'
    #
    def unstar(gist_id, params={})
      _validate_presence_of(gist_id)
      normalize! params

      delete_request("/gists/#{gist_id}/star", params)
    end

    # Check if a gist is starred
    #
    # = Examples
    #  github = Github.new
    #  github.gists.starred? 'gist-id'
    #
    def starred?(gist_id, params={})
      _validate_presence_of(gist_id)
      normalize! params

      get_request("/gists/#{gist_id}/star", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Fork a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.fork 'gist-id'
    #
    def fork(gist_id, params={})
      _validate_presence_of(gist_id)
      normalize! params

      post_request("/gists/#{gist_id}/fork", params)
    end

    # Delete a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.delete 'gist-id'
    #
    def delete(gist_id, params={})
      _validate_presence_of(gist_id)
      normalize! params

      delete_request("/gists/#{gist_id}", params)
    end

  end # Gists
end # Github
