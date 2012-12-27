# encoding: utf-8

module Github

  # These API methods let you retrieve the contents of files within a repository
  # as Base64 encoded content.
  class Repos::Contents < API

    # Get the README
    #
    # This method returns the preferred README for a repository.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.contents.readme 'user-name', 'repo-name'
    #
    #  content = Github::Repos;:Contents.new user: 'user-name', 'repo-name'
    #  content.readme
    #
    def readme(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/readme", params)
    end

    # Get contents
    #
    # This method returns the contents of any file or directory in a repository.
    #
    # = Parameters
    # * <tt>:ref</tt> - Optional string - valid Git reference, defaults to master
    #
    # = Examples
    #  github = Github.new
    #  github.repos.contents.get 'user-name', 'repo-name', 'path'
    #
    #  github = Github.new user: 'user-name', repo: 'repo-name'
    #  github.repos.contents.get path: 'README.md'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :path])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/contents/#{path}", params)
    end
    alias :find :get

    # Get archive link
    #
    # This method will return a 302 to a URL to download a tarball or zipball
    # archive for a repository. Please make sure your HTTP framework is configured
    # to follow redirects or you will need to use the Location header to make
    # a second GET request.
    #
    # Note: For private repositories, these links are temporary and expire quickly.
    #
    # = Parameters
    # * <tt>:archive_format</tt> - Required string - either tarball or zipball
    # * <tt>:ref</tt> - Optional string - valid Git reference, defaults to master
    #
    # = Examples
    #  github = Github.new
    #  github.repos.contents.archive 'user-name', 'repo-name',
    #    "archive_format" =>  "tarball",
    #    "ref" => "master"
    #
    def archive(*args)
      arguments(args, :required => [:user, :repo])
      params         = arguments.params
      archive_format = params.delete('archive_format') || 'zipball'
      ref            = params.delete('ref') || 'master'

      get_request("/repos/#{user}/#{repo}/#{archive_format}/#{ref}", params)
    end

  end # Repos::Contents
end # Github
