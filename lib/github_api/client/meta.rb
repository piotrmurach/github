# encoding: utf-8

module Github
  class Client::Meta < API
    # Get meta information about GitHub.com, the service.
    #
    # @example
    #   Github.meta.get
    #
    # @api public
    def get(*args)
      arguments(*args)

      get_request("/meta", arguments.params)
    end
  end # Client::Meta
end # Github
