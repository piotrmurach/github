# encoding: utf-8

module Github
  class Client::Search::Legacy < API
    include Github::Utils::Url

    # Search issues
    #
    # Find issues by state and keyword.
    #
    # @param [Hash] params
    # @option params [String] :state
    #   Indicates the state of the issues to return. Can be either open or closed.
    # @option params [String] :keyword
    #   The search term
    #
    # @example
    #   github = Github.new
    #   github.search.legacy.issues 'owner', 'repo-name', 'open','api'
    #   github.search.legacy.issues owner: 'owner', repo: 'repo-name', state: 'open', keyword: 'api'
    #
    # @api public
    def issues(*args)
      required = %w[ owner repo state keyword ]
      arguments(args, required: required)

      get_request("/legacy/issues/search/#{arguments.owner}/#{arguments.repo}/#{arguments.state}/#{escape_uri(arguments.keyword)}", arguments.params)
    end

    # Search repositories
    #
    # Find repositories by keyword.
    #
    # @param [Hash] params
    # @option params [String] :keyword
    #   The search term
    # @option params [String] :language
    #   Filter results by language
    # @option params [String] :start_page
    #   The page number to fetch
    # @option params [String] :sort
    #   The sort field. One of stars, forks, or updated.
    #   Default: results are sorted by best match.
    # @option params [String] :order
    #   The sort field. if sort param is provided.
    #   Can be either asc or desc.
    #
    # @example
    #   github = Github.new
    #   github.search.legacy.repos 'api'
    #   github.search.legacy.repos keyword: 'api'
    #
    # @api public
    def repos(*args)
      arguments(args, required: [:keyword])

      get_request("/legacy/repos/search/#{escape_uri(arguments.keyword)}", arguments.params)
    end
    alias :repositories :repos

    # Search users
    #
    # Find users by keyword.
    #
    # @param [Hash] params
    # @option params [String] :keyword
    #   The search term
    # @option params [String] :start_page
    #   The page number to fetch
    # @option params [String] :sort
    #   The sort field. One of stars, forks, or updated.
    #   Default: results are sorted by best match.
    # @option params [String] :order
    #   The sort field. if sort param is provided.
    #   Can be either asc or desc.
    #
    # @example
    #   github = Github.new
    #   github.search.legacy.users 'user'
    #   github.search.legacy.users keyword: 'user'
    #
    # @api public
    def users(*args)
      arguments(args, required: [:keyword])

      get_request("/legacy/user/search/#{escape_uri(arguments.keyword)}", arguments.params)
    end

    # Search email
    #
    # This API call is added for compatibility reasons only. There’s no
    # guarantee that full email searches will always be available.
    #
    # @param [Hash] params
    # @option params [String] :email
    #   The email address
    #
    # @example
    #  github = Github.new
    #  github.search.email 'email-address'
    #  github.search.email email: 'email-address'
    #
    # @api public
    def email(*args)
      arguments(args, required: [:email])
      get_request("/legacy/user/email/#{arguments.email}", arguments.params)
    end
  end # Search::Legacy
end # Github
