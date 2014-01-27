# encoding: utf-8

module Github
  class GitData < API

    Github::require_all 'github_api/git_data',
      'blobs',
      'commits',
      'references',
      'tags',
      'trees'

    # Access to GitData::Blobs API
    def blobs(options={}, &block)
      @blobs ||= ApiFactory.new('GitData::Blobs', current_options.merge(options), &block)
    end

    # Access to GitData::Commits API
    def commits(options={}, &block)
      @commits ||= ApiFactory.new('GitData::Commits', current_options.merge(options), &block)
    end

    # Access to GitData::References API
    def references(options={}, &block)
      @references ||= ApiFactory.new('GitData::References', current_options.merge(options), &block)
    end

    # Access to GitData::Tags API
    def tags(options={}, &block)
      @tags ||= ApiFactory.new('GitData::Tags', current_options.merge(options), &block)
    end

    # Access to GitData::Tags API
    def trees(options={}, &block)
      @trees ||= ApiFactory.new('GitData::Trees', current_options.merge(options), &block)
    end

  end # GitData
end # Github
