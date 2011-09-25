module Github
  class Client < API
    
    include Repos::Collaborators
    include Repos::Something
  end
end
