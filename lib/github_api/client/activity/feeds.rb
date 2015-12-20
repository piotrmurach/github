# encoding: utf-8

module Github
  class Client::Activity::Feeds < API

    # List all the feeds available to the authenticated user.
    #
    # @see https://developer.github.com/v3/activity/feeds/#list-feeds
    #
    # @example
    #  github = Github.new
    #  github.activity.feeds.list
    #
    # @api public
    def list(*args)
      arguments(args)

      response = get_request("/feeds", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list
  end
end # Github
