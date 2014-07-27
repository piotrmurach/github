# encoding: utf-8

module Github
  class Client::Emojis < API
    # Lists all the emojis.
    #
    # @example
    #   Github.emojis.list
    #
    # @api public
    def list(*args)
      arguments(args)

      get_request("/emojis", arguments.params)
    end
  end # Client::Emojis
end # Github
