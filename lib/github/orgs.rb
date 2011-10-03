# encoding: utf-8

module Github
  class Orgs < API
    extend AutoloadHelper

    autoload_all 'github/orgs',
      :Members => 'members',
      :Teams   => 'teams'

    include Github::Orgs::Members
    include Github::Orgs::Teams

    # Creates new Orgs API
    def initialize(options = {})
      super(options)
    end

  end # Orgs
end # Github
