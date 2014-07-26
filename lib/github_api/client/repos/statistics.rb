# encoding: utf-8

module Github
  # The Repository Statistics API allows you to fetch the data that GitHub uses
  # for visualizing different types of repository activity.
  class Client::Repos::Statistics < API

    # Get contributors list with additions, deletions, and commit counts
    #
    # @example
    #   github = Github.new
    #   github.repos.stats.contributors user: '...', repo: '...'
    #   github.repos.stats.contributors user: '...', repo: '...' { |stat| ... }
    #
    # @api public
    def contributors(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/stats/contributors", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get the last year of commit activity data
    #
    # Returns the last year of commit activity grouped by week.
    # The days array is a group of commits per day, starting on Sunday
    #
    # @example
    #   github = Github.new
    #   github.repos.stats.commit_activity user: '...', repo: '...'
    #   github.repos.stats.commit_activity user: '...', repo: '...' { |stat| ... }
    #
    # @api public
    def commit_activity(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/stats/commit_activity", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # Get the number of additions and deletions per week
    #
    # @example
    #  github = Github.new
    #  github.repos.stats.code_frequency user: '...', repo: '...'
    #  github.repos.stats.code_frequency user: '...', repo: '...' { |stat| ... }
    #
    # @api public
    def code_frequency(*args)
      arguments(args, required: [:user, :repo])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/stats/code_frequency", arguments.params)
    end

    # Get the weekly commit count for the repo owner and everyone else
    #
    # @example
    #   github = Github.new
    #   github.repos.stats.participation user: '...', repo: '...'
    #   github.repos.stats.participation user: '...', repo: '...' { |stat| ... }
    #
    # @api public
    def participation(*args)
      arguments(args, required: [:user, :repo])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/stats/participation", arguments.params)
    end

    # Get the number of commits per hour in each day
    #
    # @example
    #   github = Github.new
    #   github.repos.stats.punch_card user: '...', repo: '...'
    #   github.repos.stats.punch_card user: '...', repo: '...' { |stat| ... }
    #
    # @api public
    def punch_card(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/stats/punch_card", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
  end # Client::Repos::Statistics
end # Github
