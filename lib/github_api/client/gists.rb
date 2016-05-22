# encoding: utf-8

module Github
  class Client::Gists < API

    require_all 'github_api/client/gists', 'comments'

    # Access to Gists::Comments API
    namespace :comments

    # List a user's gists
    #
    # @see https://developer.github.com/v3/gists/#list-a-users-gists
    #
    # @example
    #  github = Github.new
    #  github.gists.list user: 'user-name'
    #
    # List the authenticated user’s gists or if called anonymously,
    # this will returns all public gists
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.gists.list
    #
    # List all public gists
    #
    # @see https://developer.github.com/v3/gists/#list-all-public-gists
    #
    #  github = Github.new
    #  github.gists.list :public
    #
    # @return [Hash]
    #
    # @api public
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
    alias_method :all, :list

    # List the authenticated user's starred gists
    #
    # @see https://developer.github.com/v3/gists/#list-starred-gists
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.gists.starred
    #
    # @return [Hash]
    #
    # @api public
    def starred(*args)
      arguments(args)
      response = get_request("/gists/starred", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get a single gist
    #
    # @see https://developer.github.com/v3/gists/#get-a-single-gist
    #
    # @example
    #   github = Github.new
    #   github.gists.get 'gist-id'
    #
    # Get a specific revision of gist
    #
    # @see https://developer.github.com/v3/gists/#get-a-specific-revision-of-a-gist
    #
    # @example
    #   github = Github.new
    #   github.gists.get 'gist-id', sha: '
    #
    # @return [Hash]
    #
    # @api public
    def get(*args)
      arguments(args, required: [:id])

      if (sha = arguments.params.delete('sha'))
        get_request("/gists/#{arguments.id}/#{sha}")
      else
        get_request("/gists/#{arguments.id}", arguments.params)
      end
    end
    alias_method :find, :get

    # Create a gist
    #
    # @see https://developer.github.com/v3/gists/#create-a-gist
    #
    # @param [Hash] params
    # @option params [String] :description
    #   Optional string
    # @option params [Boolean] :public
    #   Required boolean
    # @option params [Hash] :files
    #   Required hash - Files that make up this gist.
    #   The key of which should be a required string filename and
    #   the value another required hash with parameters:
    #     @option files [String] :content
    #       Required string - File contents.
    #
    # @example
    #  github = Github.new
    #  github.gists.create
    #    description: 'the description for this gist',
    #    public: true,
    #    files: {
    #      'file1.txt' => {
    #         content: 'String file contents'
    #       }
    #    }
    #
    # @return [Hash]
    #
    # @api public
    def create(*args)
      arguments(args)

      post_request("/gists", arguments.params)
    end

    # Edit a gist
    #
    # @see https://developer.github.com/v3/gists/#edit-a-gist
    #
    # @param [Hash] params
    # @option [String] :description
    #   Optional string
    # @option [Hash] :files
    #   Optional hash - Files that make up this gist.
    #   The key of which should be a optional string filename and 
    #   the value another optional hash with parameters:
    #     @option [String] :content
    #       Updated string - Update file contents.
    #     @option [String] :filename
    #       Optional string - New name for this file.
    #
    # @xample
    #  github = Github.new oauth_token: '...'
    #  github.gists.edit 'gist-id',
    #    description: 'the description for this gist',
    #    files: {
    #      'file1.txt' => {
    #         content: 'Updated file contents'
    #       },
    #      'old_name.txt' => {
    #         filename: 'new_name.txt',
    #         content: 'modified contents'
    #       },
    #      'new_file.txt' => {
    #         content: 'a new file contents'
    #       },
    #       'delete_the_file.txt' => nil
    #    }
    #
    # @return [Hash]
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:id])

      patch_request("/gists/#{arguments.id}", arguments.params)
    end

    # List gist commits
    #
    # @see https://developer.github.com/v3/gists/#list-gist-commits
    #
    # @example
    #  github = Github.new
    #  github.gists.commits 'gist-id'
    #
    # @api public
    def commits(*args)
      arguments(args, required: [:id])

      response = get_request("/gists/#{arguments.id}/commits")
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Star a gist
    #
    # @see https://developer.github.com/v3/gists/#star-a-gist
    #
    # @example
    #  github = Github.new
    #  github.gists.star 'gist-id'
    #
    # @api public
    def star(*args)
      arguments(args, required: [:id])

      put_request("/gists/#{arguments.id}/star", arguments.params)
    end

    # Unstar a gist
    #
    # @see https://developer.github.com/v3/gists/#unstar-a-gist
    #
    # @xample
    #  github = Github.new
    #  github.gists.unstar 'gist-id'
    #
    # @api public
    def unstar(*args)
      arguments(args, required: [:id])

      delete_request("/gists/#{arguments.id}/star", arguments.params)
    end

    # Check if a gist is starred
    #
    # @see https://developer.github.com/v3/gists/#check-if-a-gist-is-starred
    #
    # @example
    #   github = Github.new
    #   github.gists.starred? 'gist-id'
    #
    # @api public
    def starred?(*args)
      arguments(args, required: [:id])
      get_request("/gists/#{arguments.id}/star", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Fork a gist
    #
    # @example
    #  github = Github.new
    #  github.gists.fork 'gist-id'
    #
    # @api public
    def fork(*args)
      arguments(args, required: [:id])

      post_request("/gists/#{arguments.id}/forks", arguments.params)
    end

    # List gist forks
    #
    # @see https://developer.github.com/v3/gists/#list-gist-forks
    #
    # @example
    #   github = Github.new
    #   github.gists.forks 'gist-id'
    #
    # @api public
    def forks(*args)
      arguments(args, required: [:id])

      response = get_request("/gists/#{arguments.id}/forks")
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Delete a gist
    #
    # @see https://developer.github.com/v3/gists/#delete-a-gist
    #
    # @example
    #  github = Github.new
    #  github.gists.delete 'gist-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:id])

      delete_request("/gists/#{arguments.id}", arguments.params)
    end
  end # Gists
end # Github
