# encoding: utf-8

module Github

  # The Repository Statistics API allows you to fetch the data that GitHub uses
  # for visualizing different types of repository activity.
  class Repos::Statistics < API

    # Get contributors list with additions, deletions, and commit counts
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.stats.contributors user: '...', repo: '...'
    #  github.repos.stats.contributors user: '...', repo: '...' { |stat| ... }
    #
    def contributors(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/stats/contributors", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get the last year of commit activity data
    #
    # Returns the last year of commit activity grouped by week.
    # The days array is a group of commits per day, starting on Sunday
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.stats.commit_activity user: '...', repo: '...'
    #  github.repos.stats.commit_activity user: '...', repo: '...' { |stat| ... }
    #
    def commit_activity(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/stats/commit_activity", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get the number of additions and deletions per week
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.stats.code_frequency user: '...', repo: '...'
    #  github.repos.stats.code_frequency user: '...', repo: '...' { |stat| ... }
    #
    def code_frequency(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/stats/code_frequency", params)
    end

    # Get the weekly commit count for the repo owner and everyone else
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.stats.participation user: '...', repo: '...'
    #  github.repos.stats.participation user: '...', repo: '...' { |stat| ... }
    #
    def participation(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/stats/participation", params)
    end

    # Get the number of commits per hour in each day
    #
    # = Examples
    #
    #  github = Github.new
    #  github.repos.stats.punch_card user: '...', repo: '...'
    #  github.repos.stats.punch_card user: '...', repo: '...' { |stat| ... }
    #
    def punch_card(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = get_request("/repos/#{user}/#{repo}/stats/punch_card", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

  end # Repos::Statistics
end # Github
