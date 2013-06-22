# encoding: utf-8

module Github

  # These API methods let you retrieve the contents of files within a repository
  # as Base64 encoded content.
  class Repos::Contents < API

    REQUIRED_CONTENT_OPTIONS = %w[ path message content ]

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

    # Create a file
    #
    # This method creates a new file in a repository
    #
    # = Parameters
    # * <tt>:path</tt>    - Requried string - The content path
    # * <tt>:message</tt> - Requried string - The commit message
    # * <tt>:content</tt> - Requried string - The new file content,
    #                       which will be Base64 encoded
    # * <tt>:branch</tt>  - Optional string - The branch name. If not provided,
    #                       uses the repository’s default branch (usually master)
    # = Optional Parameters
    #
    # The <tt>author</tt> section is optional and is filled in with the
    # <tt>committer</tt> information if omitted. If the <tt>committer</tt>
    # information is omitted, the authenticated user’s information is used.
    #
    # You must provide values for both <tt>name</tt> and <tt>email</tt>, whether
    # you choose to use <tt>author</tt> or <tt>committer</tt>. Otherwise, you’ll
    # receive a <tt>500</tt> status code.
    #
    # * <tt>author.name</tt>  - string - The name of the author of the commit
    # * <tt>author.email</tt> - string - The email of the author of the commit
    # * <tt>committer.name</tt> - string - The name of the committer of the commit
    # * <tt>committer.email</tt> - string - The email of the committer of the commit
    #
    # = Examples
    #  github = Github.new
    #  github.repos.contents.create 'user-name', 'repo-name', 'path',
    #    path: 'hello.rb',
    #    content: "puts 'hello ruby'",
    #    message: "my commit message"
    #
    def create(*args)
      arguments(args, :required => [:user, :repo, :path]) do
        assert_required REQUIRED_CONTENT_OPTIONS
      end
      params = arguments.params
      params.strict_encode64('content')

      put_request("/repos/#{user}/#{repo}/contents/#{path}", params)
    end

    # Update a file
    #
    # This method updates a file in a repository
    #
    # = Parameters
    # * <tt>:path</tt>    - Requried string - The content path
    # * <tt>:message</tt> - Requried string - The commit message
    # * <tt>:content</tt> - Requried string - The new file content,
    #                       which will be Base64 encoded
    # * <tt>:sha</tt>     - Requried string -  The blob SHA of the file being replaced.
    # * <tt>:branch</tt>  - Optional string - The branch name. If not provided,
    #                       uses the repository’s default branch (usually master)
    #
    # = Examples
    #  github = Github.new
    #  github.repos.contents.update 'user-name', 'repo-name', 'path',
    #    path: 'hello.rb',
    #    content: "puts 'hello ruby again'",
    #    message: "my commit message",
    #    sha: "25b0bef9e404bd2e3233de26b7ef8cbd86d0e913"
    #
    def update(*args)
      create(*args)
    end

    # Delete a file
    #
    # This method deletes a file in a repository
    #
    # = Parameters
    # * <tt>:path</tt>    - Requried string - The content path
    # * <tt>:message</tt> - Requried string - The commit message
    # * <tt>:sha</tt>     - Requried string - The blob SHA of the file being removed.
    # * <tt>:branch</tt>  - Optional string - The branch name. If not provided,
    #                       uses the repository’s default branch (usually master)
    # = Optional Parameters
    #
    # The <tt>author</tt> section is optional and is filled in with the
    # <tt>committer</tt> information if omitted. If the <tt>committer</tt>
    # information is omitted, the authenticated user’s information is used.
    #
    # You must provide values for both <tt>name</tt> and <tt>email</tt>, whether
    # you choose to use <tt>author</tt> or <tt>committer</tt>. Otherwise, you’ll
    # receive a <tt>500</tt> status code.
    #
    # * <tt>author.name</tt>  - string - The name of the author of the commit
    # * <tt>author.email</tt> - string - The email of the author of the commit
    # * <tt>committer.name</tt> - string - The name of the committer of the commit
    # * <tt>committer.email</tt> - string - The email of the committer of the commit
    #
    # = Examples
    #  github = Github.new
    #  github.repos.contents.delete 'user-name', 'repo-name', 'path',
    #    path: 'hello.rb',
    #    message: "delete hello.rb file",
    #    sha: "329688480d39049927147c162b9d2deaf885005f"
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :path]) do
        assert_required %w[ path message sha ]
      end

      delete_request("/repos/#{user}/#{repo}/contents/#{path}", arguments.params)
    end

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
