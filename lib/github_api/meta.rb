# encoding: utf-8

module Github
  class Meta < API

    # Creates new Search API
    def initialize(options = {})
      super(options)
    end

    # Get meta information about GitHub.com, the service.
    #
    # = Examples
    #
    #   Github.meta.get
    #
    def get(params={})
      normalize! params

      get_request("/meta", params)
    end

  end # Meta
end # Github
