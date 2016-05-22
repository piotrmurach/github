# encoding: utf-8

module Github
  class Client::Activity::Feeds < API
    # List all the feeds available to the authenticated user.
    #
    # @see https://developer.github.com/v3/activity/feeds/#list-feeds
    #
    # @example
    #   github = Github.new
    #   github.activity.feeds.list
    #
    # @api public
    def list(*args)
      arguments(args)

      response = get_request("/feeds", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Get all the items for a named timeline
    #
    # @see https://developer.github.com/v3/activity/feeds/#list-feeds
    #
    # @example
    #   github = Github.new
    #   github.activity.feeds.get "timeline"
    #
    # @param [String] name
    #   the name of the timeline resource
    #
    # @api public
    def get(*args)
      arguments(args, required: [:name])

      name = arguments.name
      response = list.body._links[name]
      if response
        params = arguments.params
        params['accept'] = response.type
        get_request(response.href, params)
      end
    end
    alias_method :find, :get
  end
end # Github
