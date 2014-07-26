# encoding: utf-8

module Github
  class Client::Repos::PubSubHubbub < API
    OPTIONS = {
      :headers => {
        CONTENT_TYPE => 'application/x-www-form-urlencoded'
      }
    }

    # Subscribe to existing topic/event through pubsubhubbub
    #
    # @param [Hash] params
    # @input params [String] :topic
    #   Required string. The URI of the GitHub repository to subscribe to.
    #   The path must be in the format of /:user/:repo/events/:event.
    # @input params [String] :callback
    #   Required string - The URI to receive the updates to the topic.
    #
    # @example
    #  github = Github.new oauth_token: 'token'
    #  github.repos.pubsubhubbub.subscribe
    #    'https://github.com/:user/:repo/events/push',
    #    'github://Email?address=peter-murach@gmail.com',
    #    verify: 'sync',
    #    secret: '...'
    #
    # @api public
    def subscribe(*args)
      params = arguments(args, required: [:topic, :callback]).params
      _merge_action!("subscribe", arguments.topic, arguments.callback, params)
      params['options'] = OPTIONS

      post_request("/hub", params)
    end

    # Unsubscribe from existing topic/event through pubsubhubbub
    #
    # @param [Hash] params
    # @input params [String] :topic
    #   Required string. The URI of the GitHub repository to
    #   unsubscribe from. The path must be in the format of
    #   /:user/:repo/events/:event.
    # @input params [String] :callback
    #   Required string. The URI to unsubscribe the topic from.
    #
    # @example
    #   github = Github.new oauth_token: 'token'
    #   github.repos.pubsubhubbub.unsubscribe
    #     'https://github.com/:user/:repo/events/push',
    #     'github://Email?address=peter-murach@gmail.com',
    #     verify: 'sync',
    #     secret: '...'
    #
    # @api public
    def unsubscribe(*args)
      params = arguments(args, required: [:topic, :callback]).params
      _merge_action!("unsubscribe", arguments.topic, arguments.callback, params)
      params['options'] = OPTIONS

      post_request("/hub", params)
    end

    # Subscribe repository to service hook through pubsubhubbub
    #
    # @param [Hash] params
    # @input params [String] :event
    #   Required hash key for the type of event. The default event is push.
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.repos.pubsubhubbub.subscribe_service 'user-name', 'repo-name',
    #    'campfire',
    #     subdomain: 'github',
    #     room: 'Commits',
    #     token: 'abc123',
    #     event: 'watch'
    #
    # @api public
    def subscribe_service(*args)
      params   = arguments(args, required: [:user, :repo, :service]).params
      event    = params.delete('event') || 'push'
      topic    = "#{site}/#{arguments.user}/#{arguments.repo}/events/#{event}"
      callback = "github://#{arguments.service}?#{params.serialize}"

      subscribe(topic, callback)
    end
    alias :subscribe_repository :subscribe_service
    alias :subscribe_repo :subscribe_service

    # Subscribe repository to service hook through pubsubhubbub
    #
    # @param [Hash] params
    # @input params [String] :event
    #   Optional hash key for the type of event. The default event is push.
    #
    # @example
    #   github = Github.new oauth_token: '...'
    #   github.repos.pubsubhubbub.unsubscribe_service 'user-name', 'repo-name',
    #     'campfire'
    #
    # @example
    #   github.repos.pubsubhubbub.unsubscribe_service
    #     user: 'user-name',
    #     repo: 'repo-name',
    #     service: 'service-name'
    #
    # @api public
    def unsubscribe_service(*args)
      params   = arguments(args, required: [:user, :repo, :service]).params
      event    = params.delete('event') || 'push'
      topic    = "#{site}/#{arguments.user}/#{arguments.repo}/events/#{event}"
      callback = "github://#{arguments.service}"

      unsubscribe(topic, callback)
    end
    alias :unsubscribe_repository :unsubscribe_service
    alias :unsubscribe_repo :unsubscribe_service

    private

    def _merge_action!(action, topic, callback, params) # :nodoc:
      options = {
        "hub.mode"     => action.to_s,
        "hub.topic"    => topic.to_s,
        "hub.callback" => callback,
        "hub.verify"   => params.delete('verify') || 'sync',
        "hub.secret"   => params.delete('secret') || ''
      }
      params.merge! options
    end
  end # Client::Repos::PubSubHubbub
end # Github
