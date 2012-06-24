# encoding: utf-8

module Github
  class Search < API

    # Creates new Search API
    def initialize(options = {})
      super(options)
    end

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
    #  github.search.issues owner: 'owner', repo: 'repo-name', state: 'open', keyword: 'api'
    #
    def issues(*args)
      params = args.extract_options!
      normalize! params

      required = ['owner', 'repo', 'state', 'keyword']
      assert_required_keys required, params

      options = required.inject({}) do |hash, key|
        hash[key] = params.delete(key)
        hash
      end

      get_request("/legacy/issues/search/#{options['owner']}/#{options['repo']}/#{options['state']}/#{options['keyword']}", params)
    end

    # Search repositories
    #
    # Find repositories by keyword.
    #
    # = Parameters
    #  <tt>:keyword</tt> - search term
    #
    # = Examples
    #  github = Github.new
    #  github.search.repos keyword: 'api'
    #
    def repos(*args)
      params = args.extract_options!
      normalize! params
      assert_required_keys %w[ keyword ], params

      get_request("/legacy/repos/search/#{params.delete('keyword')}", params)
    end
    alias :repositories :repos

    # Search users
    #
    # Find users by keyword.
    #
    # = Parameters
    #  <tt>:keyword</tt> - search term
    #
    # = Examples
    #  github = Github.new
    #  github.search.users keyword: 'wycats'
    #
    def users(*args)
      params = args.extract_options!
      normalize! params
      assert_required_keys %w[ keyword ], params

      get_request("/legacy/user/search/#{params.delete('keyword')}", params)
    end

    # Search email
    #
    # This API call is added for compatibility reasons only. There’s no
    # guarantee that full email searches will always be available.
    #
    # = Parameters
    #  <tt>:keyword</tt> - search term
    #
    # = Examples
    #  github = Github.new
    #  github.search.email email: 'wycats'
    #
    def email(*args)
      params = args.extract_options!
      normalize! params
      assert_required_keys %w[ email ], params

      get_request("/legacy/user/email/#{params.delete('email')}", params)
    end

  end # Search
end # Github
