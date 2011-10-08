# encoding: utf-8

module Github
  class GitData < API
    extend AutoloadHelper

    autoload_all 'github_api/git_data',
      :Blobs      => 'blobs',
      :Commits    => 'commits',
      :References => 'references',
      :Tags       => 'tags',
      :Trees      => 'trees'

    include Github::GitData::Blobs
    include Github::GitData::Commits
    include Github::GitData::References
    include Github::GitData::Tags
    include Github::GitData::Trees

    # Creates new GitData API
    def initialize(options = {})
      super(options)
    end

  end # GitData
end # Github
