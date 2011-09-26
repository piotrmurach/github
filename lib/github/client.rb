module Github
  class Client < API
    
    include Repos::Collaborators
    include Repos::Commits
    include Repos::Downloads
    include Repos::Forks
    include Repos::Hooks
    include Repos::Keys
    include Repos::Watching

  end
end
