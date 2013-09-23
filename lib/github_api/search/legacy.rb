# encoding: utf-8

module Github
  class Search::Legacy < API
    include Github::Utils::Url

    # Search issues
    #
    # Find issues by state and keyword.
    #
    # = Parameters
    #  <tt>:state</tt> - open or closed.
    #  <tt>:keyword</tt> - search term
    #
    # = Examples
    #  github = Github.new
    #  github.search.legacy.issues 'owner', 'repo-name', 'open','api'
    #  github.search.legacy.issues owner: 'owner', repo: 'repo-name', state: 'open', keyword: 'api'
    #
    def issues(*args)
      required = %w[ owner repo state keyword ]
      arguments(args, :required => required)

      get_request("/legacy/issues/search/#{owner}/#{repo}/#{state}/#{escape_uri(keyword)}", arguments.params)
    end

    # Search repositories
    #
    # Find repositories by keyword.
    #
    # = Parameters
    #  <tt>:keyword</tt> - search term
    #  <tt>:language</tt> - Optional filter results by language
    #  <tt>:start_page</tt> - Optional page number to fetch
    #  <tt>:sort</tt> - Optional sort field. One of stars, forks, or updated.
    #                   If not provided, results are sorted by best match.
    #  <tt>:order</tt> - Optional sort order if sort param is provided.
    #                    One of asc or desc.
    #
    # = Examples
    #  github = Github.new
    #  github.search.legacy.repos 'api'
    #  github.search.legacy.repos keyword: 'api'
    #
    def repos(*args)
      arguments(args, :required => [:keyword])

      get_request("/legacy/repos/search/#{escape_uri(keyword)}", arguments.params)
    end
    alias :repositories :repos

    # Search users
    #
    # Find users by keyword.
    #
    # = Parameters
    #  <tt>:keyword</tt> - search term
    #  <tt>:start_page</tt> - Optional page number to fetch
    #  <tt>:sort</tt> - Optional sort field. One of stars, forks, or updated.
    #                   If not provided, results are sorted by best match.
    #  <tt>:order</tt> - Optional sort order if sort param is provided.
    #                    One of asc or desc.
    #
    # = Examples
    #  github = Github.new
    #  github.search.legacy.users 'user'
    #  github.search.legacy.users keyword: 'user'
    #
    def users(*args)
      arguments(args, :required => [:keyword])

      get_request("/legacy/user/search/#{escape_uri(keyword)}", arguments.params)
    end

    # Search email
    #
    # This API call is added for compatibility reasons only. There’s no
    # guarantee that full email searches will always be available.
    #
    # = Parameters
    #  <tt>:email</tt> - email address
    #
    # = Examples
    #  github = Github.new
    #  github.search.email 'email-address'
    #  github.search.email email: 'email-address'
    #
    def email(*args)
      arguments(args, :required => [:email])
      get_request("/legacy/user/email/#{email}", arguments.params)
    end

  end # Search::Legacy
end # Github
