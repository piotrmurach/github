# encoding: utf-8

module Github
  # The Search API is optimized to help you find the specific item
  # you're looking for (e.g., a specific user, a specific file
  # in a repository, etc.).
  class Client::Search < API
    include Github::Utils::Url

    require_all 'github_api/client/search', 'legacy'

    # Access to Search::Legacy API
    namespace :legacy

    # Search issues
    #
    # Find issues by state and keyword.
    # (This method returns up to 100 results per page.)
    #
    # @param [Hash] params
    # @option params [String] :q
    #   The search terms. This can be any combination of the supported
    #   issue search parameters.
    # @option params [String] :sort
    #   Optional sort field. One of comments, created, or updated.
    #   If not provided, results are sorted by  best match.
    # @option params [String] :order
    #  The sort order if sort parameter is provided.
    #  One of asc or desc. Default: desc
    #
    # @example
    #   github = Github.new
    #   github.search.issues 'query'
    #
    # @example
    #   github.search.issues q: 'query'
    #
    # @api public
    def issues(*args)
      params = arguments(args, required: [:q]).params
      params['q']      ||= arguments.q

      get_request('/search/issues' , params)
    end

    # Search repositories
    #
    # Find repositories via various criteria.
    # (This method returns up to 100 results per page.)
    #
    # @param [Hash] params
    # @option params [String] :q
    #   The search keywords, as well as any qualifiers.
    # @option params [String] :sort
    #   The sort field. One of stars, forks, or updated.
    #   Default: results are sorted by best match.
    # @option params [String] :order
    #   The sort order if sort parameter is provided.
    #   One of asc or desc. Default: desc
    #
    # @example
    #   github = Github.new
    #   github.search.repos 'query'
    #
    # @example
    #   github.search.repos q: 'query'
    #
    # @api public
    def repos(*args)
      params = arguments(args, required: [:q]).params
      params['q'] ||= arguments.q

      get_request('/search/repositories', arguments.params)
    end
    alias :repositories :repos

    # Search users
    #
    # Find users by keyword.
    #
    # @param [Hash] params
    # @option params [String] :q
    #   The search terms. This can be any combination of the supported
    #   issue search parameters.
    # @option params [String] :sort
    #   Optional sort field. One of comments, created, or updated.
    #   If not provided, results are sorted by  best match.
    # @option params [String] :order
    #  The sort order if sort parameter is provided.
    #  One of asc or desc. Default: desc
    #
    # @example
    #   github = Github.new
    #   github.search.users q: 'wycats'
    #
    # @api public
    def users(*args)
      params = arguments(args, required: [:q]).params
      params['q'] ||= arguments.q

      get_request('/search/users', arguments.params)
    end

    # Find file contents via various criteria.
    # (This method returns up to 100 results per page.)
    #
    # @param [Hash] params
    # @option params [String] :q
    #   The search terms. This can be any combination of the supported
    #   issue search parameters.
    # @option params [String] :sort
    #   Optional sort field. One of comments, created, or updated.
    #   If not provided, results are sorted by  best match.
    # @option params [String] :order
    #  The sort order if sort parameter is provided.
    #  One of asc or desc. Default: desc
    #
    # @example
    #   github = Github.new
    #   github.search.code q: 'wycats'
    #
    # @api public
    def code(*args)
      params = arguments(args, required: [:q]).params
      params['q'] ||= arguments.q

      get_request('/search/code', params)
    end
  end # Search
end # Github
