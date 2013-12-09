# encoding: utf-8

module Github
  class Orgs::Repos < API

    # List organization's repos
    #
    # List all repos of an organization
    #
    # = Examples
    #  github = Github.new
    #  github.orgs.repos.list 'org-name'
    #  github.orgs.repos.list 'org-name' { |memb| ... }
    #
    def list(*args)
      params = arguments(args, :required => [:org_name]).params

      response = get_request("/orgs/#{org_name}/repos", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

  end # Orgs::Repos
end # Github
