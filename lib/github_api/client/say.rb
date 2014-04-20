# encoding: utf-8

module Github
  class Client::Say < API

    # Generate ASCII octocat with speech bubble.
    #
    # @example
    #  Github::Client::Say.new.say "My custom string..."
    #
    # @example
    #  github = Github.new
    #  github.octocat.say "My custom string..."
    #
    def say(*args)
      params = arguments(*args).params
      params[:s] = args.shift unless args.empty?
      params['raw'] = true

      get_request('/octocat', params)
    end
  end # Say
end # Github
