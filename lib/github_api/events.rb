# encoding: utf-8

module Github
  class Events < API

    # Creates new Gists API
    def initialize(options = {})
      super(options)
    end

    # List all public events
    #
    # = Examples
    #  @github = Github.new
    #  @github.events.public_events
    #  @github.events.public_events { |event| ... }
    #
    def public_events(params={})
      _normalize_params_keys(params)

      response = get("/events", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :list_public_events :public_events

  end # Events
end # Github
