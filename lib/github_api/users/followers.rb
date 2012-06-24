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
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers
    #  github.users.followers { |user| ... }
    #
    def list(user_name=nil, params={})
      normalize! params
      response = if user_name
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
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.following
    #
    def following(user_name=nil, params={})
      normalize! params
      response = if user_name
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
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.following? 'user-name'
    #
    def following?(user_name, params={})
      _validate_presence_of user_name
      normalize! params
      get_request("/user/following/#{user_name}", params)
      true
    rescue Github::Error::NotFound
      false
    end

    # Follow a user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.follow 'user-name'
    #
    def follow(user_name, params={})
      _validate_presence_of user_name
      normalize! params
      put_request("/user/following/#{user_name}", params)
    end

    # Unfollow a user
    #
    # = Examples
    #  github = Github.new :oauth_token => '...'
    #  github.users.followers.unfollow 'user-name'
    #
    def unfollow(user_name, params={})
      _validate_presence_of user_name
      normalize! params
      delete_request("/user/following/#{user_name}", params)
    end

  end # Users::Followers
end # Github
