# encoding: utf-8

module Github
  class Say < API

    # Generate ASCII octocat with speech bubble.
    #
    # = Examples
    #  Github::Say.new.say "My custom string..."
    #
    #  github = Github.new
    #  github.octocat.say "My custom string..."
    #
    def say(*args)
      params = arguments(*args).params
      params[:s] = args.shift unless args.empty?

      get_request('/octocat', params, :raw => true)
    end

  end # Say
end # Github
