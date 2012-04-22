# encoding: utf-8

module Github
  class Repos
    module Forks

      # List repository forks
      #
      # = Parameters
      # * <tt>:sort</tt> - newest, oldest, watchers, default: newest
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.forks 'user-name', 'repo-name'
      #  @github.repos.forks 'user-name', 'repo-name' { |hook| ... }
      #
      def forks(user_name=nil, repo_name=nil, params = {})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = get("/repos/#{user}/#{repo}/forks", params)
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :repo_forks :forks
      alias :repository_forks :forks

      # Create a fork for the authenticated user
      #
      # = Parameters
      # * <tt>:org</tt> - Optional string - the name of the service that is being called.
      #
      # = Examples
      #  @github = Github.new
      #  @github.repos.create_fork 'user-name', 'repo-name',
      #    "org" =>  "github"
      #
      def create_fork(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys(params)
        _filter_params_keys(%w[ org ], params)

        post("/repos/#{user}/#{repo}/forks", params)
      end

    end # Forks
  end # Repos
end # Github
