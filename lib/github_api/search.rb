# encoding: utf-8

module Github

  # The Search API is optimized to help you find the specific item
  # you're looking for (e.g., a specific user, a specific file
  # in a repository, etc.).
  class Search < API
    include Github::Utils::Url

    PREVIEW_MEDIA = 'application/vnd.github.preview'.freeze # :nodoc:

    Github::require_all 'github_api/search', 'legacy'

    # Access to Search::Legacy API
    def legacy(options = {}, &block)
      @legacy ||= ApiFactory.new('Search::Legacy',
                                 current_options.merge(options), &block)
    end

    # Search issues
    #
    # Find issues by state and keyword.
    # (This method returns up to 100 results per page.)
    #
    # = Parameters
    #  <tt>:q</tt> - The search terms. This can be any combination of the
    #                supported issue search parameters.
    #  <tt>:sort</tt> - Optional sort field. One of comments, created, or
    #                   updated. If not provided, results are sorted by
    #                   best match.
    #  <tt>:order</tt> - Optional Sort order if sort parameter is provided.
    #                    One of asc or desc; the default is desc.
    #
    # = Examples
    #  github = Github.new
    #  github.search.legacy.issues 'query'
    #  github.search.legacy.issues q: 'query'
    #
    def issues(*args)
      params = arguments(args, required: [:q]).params
      params['q']      ||= q
      params['accept'] ||= PREVIEW_MEDIA

      get_request('/search/issues' , params)
    end

    # Search repositories
    #
    # Find repositories via various criteria.
    # (This method returns up to 100 results per page.)
    #
    # = Parameters
    #  <tt>:q</tt> - The search terms. This can be any combination of the
    #                supported issue search parameters.
    #  <tt>:sort</tt> - Optional sort field. One of stars, forks, or updated.
    #                   If not provided, results are sorted by best match.
    #  <tt>:order</tt> - Optional Sort order if sort parameter is provided.
    #                    One of asc or desc; the default is desc.
    #
    # = Examples
    #  github = Github.new
    #  github.search.repos 'query'
    #  github.search.repos q: 'query'
    #
    def repos(*args)
      params = arguments(args, required: [:q]).params
      params['q']      ||= q
      params['accept'] ||= PREVIEW_MEDIA

      get_request('/search/repositories', arguments.params)
    end
    alias :repositories :repos

    # Search users
    #
    # Find users by keyword.
    #
    # = Parameters
    #  <tt>:q</tt> - The search terms. This can be any combination of the
    #                supported issue search parameters.
    #  <tt>:sort</tt> - Optional sort field. One of followers, repositories, or
    #                   If not provided, results are sorted by best match.
    #  <tt>:order</tt> - Optional Sort order if sort parameter is provided.
    #                    One of asc or desc; the default is desc.
    #
    # = Examples
    #  github = Github.new
    #  github.search.users keyword: 'wycats'
    #
    def users(*args)
      params = arguments(args, required: [:q]).params
      params['q']      ||= q
      params['accept'] ||= PREVIEW_MEDIA

      get_request('/search/users', arguments.params)
    end

    # Find file contents via various criteria.
    # (This method returns up to 100 results per page.)
    #
    # = Parameters
    #  <tt>:q</tt> - The search terms. This can be any combination of the
    #                supported issue search parameters.
    #  <tt>:sort</tt> - Optional sort field. Can only be indexed, which
    #                   indicates how recently a file has been indexed
    #                   by the GitHub search infrastructure. If not provided,
    #                   results are sorted by best match.
    #  <tt>:order</tt> - Optional Sort order if sort parameter is provided.
    #                    One of asc or desc; the default is desc.
    #
    # = Examples
    #  github = Github.new
    #  github.search.code email: 'wycats'
    #
    def code(*args)
      params = arguments(args, required: [:q]).params
      params['q']      ||= q
      params['accept'] ||= PREVIEW_MEDIA

      get_request('/search/code', params)
    end

  end # Search
end # Github
