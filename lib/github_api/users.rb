# encoding: utf-8

module Github
  class Users < API

    # Load all the modules after initializing Repos to avoid superclass mismatch
    Github::require_all 'github_api/users',
      'emails',
      'followers',
      'keys'

    VALID_USER_PARAMS_NAMES = %w[
      name
      email
      blog
      company
      location
      hireable
      bio
    ].freeze

    # Access to Users::Emails API
    def emails(options={}, &block)
      @emails ||= ApiFactory.new('Users::Emails', current_options.merge(options), &block)
    end

    # Access to Users::Followers API
    def followers(options={}, &block)
      @followers ||= ApiFactory.new('Users::Followers', current_options.merge(options), &block)
    end

    # Access to Users::Keys API
    def keys(options={}, &block)
      @keys ||= ApiFactory.new('Users::Keys', current_options.merge(options), &block)
    end

    # List all users.
    #
    # This provides a dump of every user, in the order that they signed up
    # for GitHub.
    #
    # = Parameters
    # * <tt>:since</tt> - The integer ID of the last User that you’ve seen.
    #
    # = Examples
    #  users = Github::Users.new
    #  users.list
    #
    def list(*args)
      arguments(args)

      response = get_request("/users", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single unauthenticated user
    #
    # = Examples
    #  github = Github.new
    #  github.users.get user: 'user-name'
    #
    # Get the authenticated user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.get
    #
    def get(*args)
      params = arguments(args).params

      if user_name = params.delete('user')
        get_request("/users/#{user_name}", params)
      else
        get_request("/user", params)
      end
    end
    alias :find :get

    # Update the authenticated user
    #
    # = Inputs
    # * <tt>:name</tt> - Optional string
    # * <tt>:email</tt> - Optional string - publically visible email address
    # * <tt>:blog</tt> - Optional string
    # * <tt>:company</tt> - Optional string
    # * <tt>:location</tt> - Optional string
    # * <tt>:hireable</tt> - Optional boolean
    # * <tt>:bio</tt> - Optional string
    #
    # = Examples
    #  github = Github.new :oauth_token => '..'
    #  github.users.update
    #    "name" => "monalisa octocat",
    #    "email" => "octocat@github.com",
    #    "blog" => "https://github.com/blog",
    #    "company" => "GitHub",
    #    "location" => "San Francisco",
    #    "hireable" => true,
    #    "bio" => "There once..."
    #
    def update(*args)
      arguments(args) do
        sift VALID_USER_PARAMS_NAMES
      end

      patch_request("/user", arguments.params)
    end

  end # Users
end # Github
