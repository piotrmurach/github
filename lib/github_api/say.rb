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
      params['raw'] = true

      get_request('/octocat', params)
    end

  end # Say
end # Github
