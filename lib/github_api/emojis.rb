# encoding: utf-8

module Github
  class Emojis < API


    # lists all the emojis.
    #
    # = Examples
    #
    #  Github.emojis.list
    #
    def list(params={})
      normalize! params

      get_request("/emojis", params)
    end

  end # Emojis
end # Github
