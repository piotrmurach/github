# encoding: utf-8

module Github
  class Client::Users::Followers < API

    # List a user's followers
    #
    # @xample
    #  github = Github.new
    #  github.users.followers.list 'user-name'
    #  github.users.followers.list 'user-name' { |user| ... }
    #
    # List the authenticated user's followers
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.users.followers
    #  github.users.followers { |user| ... }
    #
    # @api public
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
    # @example
    #  github = Github.new
    #  github.users.followers.following 'user-name'
    #  github.users.followers.following 'user-name' { |user| ... }
    #
    # List who the authenicated user is following
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.following
    #
    # @api public
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
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.users.followers.following? 'user-name'
    #   github.users.followers.following? username: 'user-name'
    #
    # Check if one user follows another
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.users.followers.following? username: 'user-name',
    #     target_user: 'target-user-name'
    #
    # @api public
    def following?(*args)
      arguments(args, required: [:username])
      params = arguments.params
      if target_user = params.delete('target_user')
        get_request("/users/#{arguments.username}/following/#{target_user}", params)
      else
        get_request("/user/following/#{arguments.username}", params)
      end
      true
    rescue Github::Error::NotFound
      false
    end

    # Follow a user
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.follow 'user-name'
    #  github.users.followers.follow username: 'user-name'
    #
    # @api public
    def follow(*args)
      arguments(args, required: [:username])
      put_request("/user/following/#{arguments.username}", arguments.params)
    end

    # Unfollow a user
    #
    # @example
    #  github = Github.new oauth_token: '...'
    #  github.users.followers.unfollow 'user-name'
    #  github.users.followers.unfollow username: 'user-name'
    #
    def unfollow(*args)
      arguments(args, required: [:username])
      delete_request("/user/following/#{arguments.username}", arguments.params)
    end
  end # Users::Followers
end # Github
