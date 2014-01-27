# encoding: utf-8

module Github
  class Gists < API

    Github::require_all 'github_api/gists', 'comments'

    REQUIRED_GIST_INPUTS = %w[
      description
      public
      files
      content
    ].freeze

    # Access to Gists::Comments API
    def comments(options={}, &block)
      @comments ||= ApiFactory.new('Gists::Comments', current_options.merge(options), &block)
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
    # List all public gists
    #
    #  github = Github.new
    #  github.gists.list :public
    #
    def list(*args)
      params = arguments(args).params

      response = if (user = params.delete('user'))
        get_request("/users/#{user}/gists", params)
      elsif args.map(&:to_s).include?('public')
        get_request("/gists/public", params)
      else
        get_request("/gists", params)
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
    def starred(*args)
      arguments(args)
      response = get_request("/gists/starred", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get a single gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.get 'gist-id'
    #
    def get(*args)
      arguments(args, :required => [:gist_id])

      get_request("/gists/#{gist_id}", arguments.params)
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
    def create(*args)
      arguments(args) do
        assert_required REQUIRED_GIST_INPUTS
      end

      post_request("/gists", arguments.params)
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
    def edit(*args)
      arguments(args, :required => [:gist_id])

      patch_request("/gists/#{gist_id}", arguments.params)
    end

    # Star a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.star 'gist-id'
    #
    def star(*args)
      arguments(args, :required => [:gist_id])

      put_request("/gists/#{gist_id}/star", arguments.params)
    end

    # Unstar a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.unstar 'gist-id'
    #
    def unstar(*args)
      arguments(args, :required => [:gist_id])

      delete_request("/gists/#{gist_id}/star", arguments.params)
    end

    # Check if a gist is starred
    #
    # = Examples
    #  github = Github.new
    #  github.gists.starred? 'gist-id'
    #
    def starred?(*args)
      arguments(args, :required => [:gist_id])
      get_request("/gists/#{gist_id}/star", arguments.params)
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
    def fork(*args)
      arguments(args, :required => [:gist_id])

      post_request("/gists/#{gist_id}/fork", arguments.params)
    end

    # Delete a gist
    #
    # = Examples
    #  github = Github.new
    #  github.gists.delete 'gist-id'
    #
    def delete(*args)
      arguments(args, :required => [:gist_id])

      delete_request("/gists/#{gist_id}", arguments.params)
    end

  end # Gists
end # Github
