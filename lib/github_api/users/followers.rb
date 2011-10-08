# encoding: utf-8

module Github
  class Users
    module Followers

      # List a user's followers
      #
      # = Examples
      #  @github = Github.new
      #  @github.users.followers 'user-name'
      #  @github.users.followers 'user-name' { |user| ... }
      #
      # List the authenticated user's followers
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.following
      #  @github.users.following { |user| ... }
      #
      def followers(user_name=nil, params={})
        _normalize_params_keys(params)
        response = if user_name
          get("/users/#{user_name}/followers", params)
        else
          get("/user/followers", params)
        end
        return response unless block_given?
        response.each { |el| yield el }
      end

      # List who a user is following
      #
      # = Examples
      #  @github = Github.new
      #  @github.users.following 'user-name'
      #  @github.users.following 'user-name' { |user| ... }
      #
      # List who the authenicated user is following
      #
      # = Examples
      #
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.following
      #
      def following(user_name=nil, params={})
        _normalize_params_keys(params)
        response = if user_name
          get("/users/#{user_name}/following", params)
        else
          get("/user/following", params)
        end
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Check if you are following a user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.following? 'user-name'
      #
      def following?(user_name, params={})
        _validate_presence_of user_name
        _normalize_params_keys(params)
        get("/user/following/#{user_name}", params)
        true
      rescue Github::ResourceNotFound
        false
      end

      # Follow a user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.follow 'user-name'
      #
      def follow(user_name, params={})
        _validate_presence_of user_name
        _normalize_params_keys(params)
        put("/user/following/#{user_name}", params)
      end

      # Unfollow a user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.unfollow 'user-name'
      #
      def unfollow(user_name, params={})
        _validate_presence_of user_name
        _normalize_params_keys(params)
        delete("/user/following/#{user_name}", params)
      end

    end # Followers
  end # Users
end # Github
