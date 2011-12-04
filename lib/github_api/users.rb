# encoding: utf-8

module Github
  class Users < API
    extend AutoloadHelper

    # Load all the modules after initializing Repos to avoid superclass mismatch
    autoload_all 'github_api/users',
      :Emails    => 'emails',
      :Followers => 'followers',
      :Keys      => 'keys'

    include Github::Users::Emails
    include Github::Users::Followers
    include Github::Users::Keys

    VALID_USER_PARAMS_NAMES = %w[
      name
      email
      blog
      company
      location
      hireable
      bio
    ].freeze

    # Creates new Repos API
    def initialize(options = {})
      super(options)
    end

    # Get a single unauthenticated user
    #
    # = Examples
    #  @github = Github.new
    #  @github.users.get_user 'user-name'
    #
    # Get the authenticated user
    #
    # = Examples
    #  @github = Github.new :oauth_token => '...'
    #  @github.users.get_user
    #
    def get_user(user_name=nil, params={})
      _normalize_params_keys(params)
      if user_name
        get("/users/#{user_name}", params)
      else
        get("/user", params)
      end
    end
    alias :get_auth_user :get_user

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
    #  @github = Github.new :oauth_token => '..'
    #  @github.users.update_user
    #    "name" => "monalisa octocat",
    #    "email" => "octocat@github.com",
    #    "blog" => "https://github.com/blog",
    #    "company" => "GitHub",
    #    "location" => "San Francisco",
    #    "hireable" => true,
    #    "bio" => "There once..."
    #
    def update_user(params={})
      _normalize_params_keys(params)
      _filter_params_keys(VALID_USER_PARAMS_NAMES, params)
      patch("/user", params)
    end
    alias :update_authenticated_user :update_user

  end # Users
end # Github
