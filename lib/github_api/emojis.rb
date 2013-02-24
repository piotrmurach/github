# encoding: utf-8

module Github
  class Emojis < API


    # lists all the emojis.
    #
    # = Examples
    #
    #  Github.emojis.list
    #
    def list(*args)
      arguments(args)

      get_request("/emojis", arguments.params)
    end

  end # Emojis
end # Github
