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

    # Creates new GitData API
    def initialize(options = {})
      super(options)
    end

    # Access to GitData::Blobs API
    def blobs
      @blobs ||= ApiFactory.new 'GitData::Blobs'
    end

    # Access to GitData::Commits API
    def commits
      @commits ||= ApiFactory.new 'GitData::Commits'
    end

    # Access to GitData::References API
    def references
      @references ||= ApiFactory.new 'GitData::References'
    end

    # Access to GitData::Tags API
    def tags
      @tags ||= ApiFactory.new 'GitData::Tags'
    end

    # Access to GitData::Tags API
    def trees
      @trees ||= ApiFactory.new 'GitData::Trees'
    end

  end # GitData
end # Github
