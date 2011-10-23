# encoding: utf-8

module Github
  class Repos
    module PubSubHubbub

      # Subscribe to existing topic through pubsubhubbub
      #
      # = Parameters
      # * topic - Required string - The URI of the GitHub repository to subscribe to. The path must be in the format of /:user/:repo/events/:event.
      # * callback - Required string - The URI to receive the updates to the topic.
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.subscribe 'https://github.com/:user/:repo/events/push',
      #    'github://Email?address=peter-murach@gmail.com',
      #    :verify => 'sync',
      #    :secret => '...'
      #
      def subscribe(topic, callback, params={})
        _validate_presence_of topic, callback
        _normalize_params_keys(params)
        _merge_action!("subscribe", topic, callback, params)

        post("/hub", params)
      end

      # Unsubscribe from existing topic though pubsubhubbub
      #
      #
      def unsubscribe(topic, callback, params={})
        _validate_presence_of topic, callback
        _normalize_params_keys(params)
        _merge_action!("unsubscribe", topic, callback, params)

        post("/hub", params)
      end

      # Subscribe repository to service hook through pubsubhubbub
      #
      # = Parameters
      # * repo-name - Required string,
      # * service-name - Required string
      # * <tt>:event</tt> - Required hash key for the type of event. The default event is <tt>push</tt>
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.repos.subscribe_service 'user-name', 'repo-name', 'campfire',
      #    :subdomain => 'github',
      #    :room => 'Commits',
      #    :token => 'abc123',
      #    :event => 'watch'
      #
      def subscribe_service(user_name, repo_name, service_name, params={})
        _validate_presence_of user_name, repo_name, service_name
        _normalize_params_keys(params)
        event = params.delete('event') || 'push'
        topic = "https://github.com/#{user_name}/#{repo_name}/events/#{event}"
        callback = "github://#{service_name}?#{params.serialize}"

        subscribe(topic, callback)
      end
      alias :subscribe_repository :subscribe_service

      # Subscribe repository to service hook through pubsubhubbub
      #
      # = Parameters
      # * repo-name - Required string,
      # * service-name - Required string
      # * <tt>:event</tt> - Optional hash key for the type of event. The default event is <tt>push</tt>
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.repos.unsubscribe_service 'user-name', 'repo-name', 'campfire'
      #
      def unsubscribe_service(user_name, repo_name, service_name, params={})
        _validate_presence_of user_name, repo_name, service_name
        _normalize_params_keys(params)
        event = params.delete('event') || 'push'
        topic = "https://github.com/#{user_name}/#{repo_name}/events/#{event}"
        callback = "github://#{service_name}"

        unsubscribe(topic, callback)
      end
      alias :unsubscribe_repository :unsubscribe_service

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

    end # PubSubHubbub
  end # Repos
end # Github
