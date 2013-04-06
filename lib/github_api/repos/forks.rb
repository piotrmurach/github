# encoding: utf-8

module Github
  class Repos::Forks < API

    # List repository forks
    #
    # = Parameters
    # * <tt>:sort</tt> - newest, oldest, watchers, default: newest
    #
    # = Examples
    #  github = Github.new
    #  github.repos.forks.list 'user-name', 'repo-name'
    #  github.repos.forks.list 'user-name', 'repo-name' { |fork| ... }
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])

      response = get_request("/repos/#{user}/#{repo}/forks", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Create a fork for the authenticated user
    #
    # = Inputs
    # * <tt>:organization</tt> - Optional string - the name of the service that is being called.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.forks.create 'user-name', 'repo-name',
    #    "organization" => "github"
    #
    def create(*args)
      arguments(args, :required => [:user, :repo])

      post_request("/repos/#{user}/#{repo}/forks", arguments.params)
    end

  end # Repos::Forks
end # Github
