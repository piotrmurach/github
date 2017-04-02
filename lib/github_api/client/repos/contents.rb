# encoding: utf-8

module Github
  # These API methods let you retrieve the contents of files within a repository
  # as Base64 encoded content.
  class Client::Repos::Contents < API

    REQUIRED_CONTENT_OPTIONS = %w[ path message content ]

    # Get the README
    #
    # This method returns the preferred README for a repository.
    #
    # @param [Hash] params
    # @option params [String] :ref
    #   The name of the commit/branch/tag.
    #   Default: the repository’s default branch (usually master)
    #
    # @example
    #   github = Github.new
    #   github.repos.contents.readme 'user-name', 'repo-name'
    #
    # @example
    #   content = Github::Client::Repos::Contents.new user: 'user-name', repo: 'repo-name'
    #   content.readme
    #
    # @api public
    def readme(*args)
      arguments(args, required: [:user, :repo])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/readme", arguments.params)
    end

    # Get contents
    #
    # This method returns the contents of any file or directory in a repository.
    #
    # @param [Hash] params
    # @option params [String] :path
    #   The content path.
    # @option params [String] :ref
    #   The name of the commit/branch/tag.
    #   Default: the repository’s default branch (usually master)
    #
    # @example
    #   github = Github.new
    #   github.repos.contents.get 'user-name', 'repo-name', 'path'
    #
    # @example
    #   github = Github.new user: 'user-name', repo: 'repo-name'
    #   github.repos.contents.get path: 'README.md'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :path])

      get_request("/repos/#{arguments.user}/#{arguments.repo}/contents/#{arguments.path}", arguments.params)
    end
    alias :find :get

    # Create a file
    #
    # This method creates a new file in a repository
    #
    # @param [Hash] params
    # @option params [String] :path
    #   Requried string. The content path
    # @option params [String]
    # @option params [String] :message
    #   Requried string. The commit message.
    # @option params [String] :content
    #   Requried string. The new file content, which will be Base64 encoded
    # @option params [String] :branch
    #   The branch name. If not provided, uses the repository’s
    #   default branch (usually master)
    #
    # Optional Parameters
    #
    # The :author section is optional and is filled in with the
    # :committer information if omitted. If the :committer
    # information is omitted, the authenticated user’s information is used.
    #
    # You must provide values for both :name and :email, whether
    # you choose to use :author or :committer. Otherwise, you’ll
    # receive a 500 status code.
    #
    # Both the author and commiter parameters have the same keys:
    #
    # @option params [String] :name
    #   The name of the author (or commiter) of the commit
    # @option params [String] :email
    #   The email of the author (or commiter) of the commit
    #
    # @example
    #   github = Github.new
    #   github.repos.contents.create 'user-name', 'repo-name', 'path',
    #     path: 'hello.rb',
    #     content: "puts 'hello ruby'",
    #     message: "my commit message"
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :path]) do
        assert_required REQUIRED_CONTENT_OPTIONS
      end
      params = arguments.params
      params.strict_encode64('content')

      put_request("/repos/#{arguments.user}/#{arguments.repo}/contents/#{arguments.path}", params)
    end

    # Update a file
    #
    # This method updates a file in a repository
    #
    # @param [Hash] params
    # @option params [String] :path
    #   Requried string. The content path
    # @option params [String]
    # @option params [String] :message
    #   Requried string. The commit message.
    # @option params [String] :content
    #   Requried string. The new file content, which will be Base64 encoded
    # @option params [String] :sha
    #   Required string. The blob SHA of the file being replaced.
    # @option params [String] :branch
    #   The branch name. If not provided, uses the repository’s
    #   default branch (usually master)
    #
    # Optional Parameters
    #
    # The :author section is optional and is filled in with the
    # :committer information if omitted. If the :committer
    # information is omitted, the authenticated user’s information is used.
    #
    # You must provide values for both :name and :email, whether
    # you choose to use :author or :committer. Otherwise, you’ll
    # receive a 500 status code.
    #
    # Both the author and commiter parameters have the same keys:
    #
    # @option params [String] :name
    #   The name of the author (or commiter) of the commit
    # @option params [String] :email
    #   The email of the author (or commiter) of the commit
    #
    # @example
    #   github = Github.new
    #   github.repos.contents.update 'user-name', 'repo-name', 'path',
    #     path: 'hello.rb',
    #     content: "puts 'hello ruby again'",
    #     message: "my commit message",
    #     sha: "25b0bef9e404bd2e3233de26b7ef8cbd86d0e913"
    #
    # @api public
    def update(*args)
      create(*args)
    end

    # Delete a file
    #
    # This method deletes a file in a repository
    #
    # @param [Hash] params
    # @option params [String] :path
    #   Requried string. The content path
    # @option params [String]
    # @option params [String] :message
    #   Requried string. The commit message.
    # @option params [String] :sha
    #   Required string. The blob SHA of the file being replaced.
    # @option params [String] :branch
    #   The branch name. If not provided, uses the repository’s
    #   default branch (usually master)
    #
    # Optional Parameters
    #
    # The :author section is optional and is filled in with the
    # :committer information if omitted. If the :committer
    # information is omitted, the authenticated user’s information is used.
    #
    # You must provide values for both :name and :email, whether
    # you choose to use :author or :committer. Otherwise, you’ll
    # receive a 500 status code.
    #
    # Both the author and commiter parameters have the same keys:
    #
    # @option params [String] :name
    #   The name of the author (or commiter) of the commit
    # @option params [String] :email
    #   The email of the author (or commiter) of the commit
    #
    # @example
    #  github = Github.new
    #  github.repos.contents.delete 'user-name', 'repo-name', 'path',
    #    path: 'hello.rb',
    #    message: "delete hello.rb file",
    #    sha: "329688480d39049927147c162b9d2deaf885005f"
    #
    def delete(*args)
      arguments(args, required: [:user, :repo, :path]) do
        assert_required %w[ path message sha ]
      end

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/contents/#{arguments.path}", arguments.params)
    end

    # Get archive link
    #
    # This method will return a 302 to a URL to download a tarball or zipball
    # archive for a repository. Please make sure your HTTP framework is configured
    # to follow redirects or you will need to use the Location header to make
    # a second GET request.
    #
    # @note
    #   For private repositories, these links are temporary and expire quickly.
    #
    # @param [Hash] params
    # @input params [String] :archive_format
    #   Required string. Either tarball or zipball. Default: tarball
    # @input params [String] :ref
    #   Optional string. A valid Git reference.
    #   Default: the repository’s default branch (usually master)
    #
    # @example
    #  github = Github.new
    #  github.repos.contents.archive 'user-name', 'repo-name',
    #    archive_format: "tarball",
    #    ref: "master"
    #
    # @api public
    def archive(*args)
      arguments(args, required: [:user, :repo])
      params         = arguments.params
      archive_format = params.delete('archive_format') || 'tarball'
      ref            = params.delete('ref') || 'master'

      disable_redirects do
        response = get_request("/repos/#{arguments.user}/#{arguments.repo}/#{archive_format}/#{ref}", params)
        response.headers.location
      end
    end
  end # Client::Repos::Contents
end # Github
