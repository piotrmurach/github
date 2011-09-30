# encoding: utf-8

module Github
  class Issues < API
    extend AutoloadHelper
    
    autoload_all 'github/issues', 
      :Comments   => 'comments',
      :Events     => 'events',
      :Labels     => 'labels',
      :Milestones => 'milestones'
    
    # Creates new Issues API
    def initialize(options = {})
      super(options)
    end

  end # Issues
end # Github
