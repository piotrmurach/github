# encoding: utf-8

module Github
  class Users::Followers < API

    # List a user's followers
    #
    # = Examples
    #  github = Github.new
    #  github.users.followers.list 'user-name'
    #  github.users.followers.list 'user-name' { |user| ... }
    #
    # List the authenticated user's followers
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.followers
    #  github.users.followers { |user| ... }
    #
    def list(*args)
      params = arguments(args).params

      response = if user_name = arguments.remaining.first
        get_request("/users/#{user_name}/followers", params)
      else
        get_request("/user/followers", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # List who a user is following
    #
    # = Examples
    #  github = Github.new
    #  github.users.followers.following 'user-name'
    #  github.users.followers.following 'user-name' { |user| ... }
    #
    # List who the authenicated user is following
    #
    # = Examples
    #
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.following
    #
    def following(*args)
      params = arguments(args).params

      response = if user_name = arguments.remaining.first
        get_request("/users/#{user_name}/following", params)
      else
        get_request("/user/following", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Check if you are following a user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.following? 'user-name'
    #  github.users.followers.following? user: 'user-name'
    #
    def following?(*args)
      arguments(args, :required => [:user])
      get_request("/user/following/#{user}", arguments.params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Follow a user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.follow 'user-name'
    #  github.users.followers.follow user: 'user-name'
    #
    def follow(*args)
      arguments(args, :required => [:user])
      put_request("/user/following/#{user}", arguments.params)
    end

    # Unfollow a user
    #
    # = Examples
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.unfollow 'user-name'
    #  github.users.followers.unfollow user: 'user-name'
    #
    def unfollow(*args)
      arguments(args, :required => [:user])
      delete_request("/user/following/#{user}", arguments.params)
    end

  end # Users::Followers
end # Github
