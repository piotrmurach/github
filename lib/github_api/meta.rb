# encoding: utf-8

module Github
  class Meta < API

    # Get meta information about GitHub.com, the service.
    #
    # = Examples
    #
    #   Github.meta.get
    #
    def get(*args)
      arguments(*args)

      get_request("/meta", arguments.params)
    end

  end # Meta
end # Github
