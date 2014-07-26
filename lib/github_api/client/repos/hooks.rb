# encoding: utf-8

module Github
  # The Repository Hooks API manages the post-receive web and
  # service hooks for a repository.
  class Client::Repos::Hooks < API

    VALID_HOOK_PARAM_NAMES = %w[
      name
      config
      active
      events
      add_events
      remove_events
    ].freeze # :nodoc:

    # Active hooks can be configured to trigger for one or more events.
    # The default event is push. The available events are:
    VALID_HOOK_PARAM_VALUES = {
      'events' => %w[
        push
        issues
        issue_comment
        commit_comment
        pull_request
        gollum
        watch
        download
        fork
        fork_apply
        member
        public
      ]
    }.freeze # :nodoc:

    REQUIRED_PARAMS = %w[ name config ].freeze # :nodoc:

    # List repository hooks
    #
    # @example
    #   github = Github.new
    #   github.repos.hooks.list 'user-name', 'repo-name'
    #   github.repos.hooks.list 'user-name', 'repo-name' { |hook| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/hooks", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single hook
    #
    # @example
    #   github = Github.new
    #   github.repos.hooks.get 'user-name', 'repo-name', 'hook-id'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :id])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/hooks/#{arguments.id}", arguments.params)
    end
    alias :find :get

    # Create a hook
    #
    # @param [Hash] params
    # @input params [String] :name
    #   Required. The name of the service that is being called.
    # @input params [Hash] :config
    #   Required. Key/value pairs to provide settings for this hook.
    #   These settings vary between the services and are defined in
    #   the github-services repository. Booleans are stored internally
    #   as “1” for true, and “0” for false. Any JSON true/false values
    #   will be converted automatically.
    # @input params [Array] :events
    #   Determines what events the hook is triggered for. Default: ["push"]
    # @input params [Boolean] :active
    #   Determines whether the hook is actually triggered on pushes.
    #
    # To create a webhook, the following fields are required by the config:
    #
    # @input config [String] :url
    #   A required string defining the URL to which the payloads
    #   will be delivered.
    # @input config [String] :content_type
    #   An optional string defining the media type used to serialize
    #   the payloads. Supported values include json and form.
    #   The default is form.
    # @input config [String] :secret
    #   An optional string that’s passed with the HTTP requests as
    #   an X-Hub-Signature header. The value of this header is
    #   computed as the HMAC hex digest of the body,
    #   using the secret as the key.
    # @input config [String] :insecure_ssl
    #   An optional string that determines whether the SSL certificate
    #   of the host for url will be verified when delivering payloads.
    #   Supported values include "0" (verification is performed) and
    #   "1" (verification is not performed). The default is "0".
    #
    # @example
    #   github = Github.new
    #   github.repos.hooks.create 'user-name', 'repo-name',
    #     name:  "web",
    #     active: true,
    #     config: {
    #       url: "http://something.com/webhook"
    #     }
    #   }
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_HOOK_PARAM_NAMES, recursive: false
        assert_required REQUIRED_PARAMS
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/hooks", arguments.params)
    end

    # Edit a hook
    #
    # @param [Hash] params
    # @input params [Hash] :config
    #   Required. Key/value pairs to provide settings for this hook.
    #   These settings vary between the services and are defined in
    #   the github-services repository. Booleans are stored internally
    #   as “1” for true, and “0” for false. Any JSON true/false values
    #   will be converted automatically.
    # @input params [Array] :events
    #   Determines what events the hook is triggered for. Default: ["push"]
    # @input params [Array] :add_events
    #   Determines a list of events to be added to the list of events
    #   that the Hook triggers for.
    # @input params [Array] :remove_events
    #   Determines a list of events to be removed from the list of
    #   events that the Hook triggers for.
    # @input params [Boolean] :active
    #   Determines whether the hook is actually triggered on pushes.
    #
    # @example
    #  github = Github.new
    #  github.repos.hooks.edit 'user-name', 'repo-name', 'hook-id',
    #    "name" => "campfire",
    #    "active" =>  true,
    #    "config" =>  {
    #      "subdomain" => "github",
    #      "room" =>  "Commits",
    #      "token" => "abc123"
    #    }
    #
    # @api public
    def edit(*args)
      arguments(args, required: [:user, :repo, :id]) do
        permit VALID_HOOK_PARAM_NAMES, recursive: false
        assert_required REQUIRED_PARAMS
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/hooks/#{arguments.id}", arguments.params)
    end

    # Test a hook
    #
    # This will trigger the hook with the latest push to the current
    # repository if the hook is subscribed to push events. If the hook
    # is not subscribed to push events, the server will respond with 204
    # but no test POST will be generated.
    #
    # @example
    #  github = Github.new
    #  github.repos.hooks.test 'user-name', 'repo-name', 'hook-id'
    #
    # @api public
    def test(*args)
      arguments(args, required: [:user, :repo, :id])

      post_request("/repos/#{arguments.user}/#{arguments.repo}/hooks/#{arguments.id}/tests", arguments.params)
    end

    # Ping a hook
    #
    # This will trigger a ping event to be sent to the hook.
    #
    # @example
    #   github = Github.new
    #   github.repos.hooks.ping 'user-name', 'repo-name', 'hook-id'
    #
    # @api public
    def ping(*args)
      arguments(args, required: [:user, :repo, :id])

      post_request("/repos/#{arguments.user}/#{arguments.repo}/hooks/#{arguments.id}/pings", arguments.params)
    end

    # Delete a hook
    #
    # @example
    #   github = Github.new
    #   github.repos.hooks.delete 'user-name', 'repo-name', 'hook-id'
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :id])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/hooks/#{arguments.id}", arguments.params)
    end
  end # Client::Repos::Hooks
end # Github
