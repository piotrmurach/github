# encoding: utf-8

module Github
  class GitData::Commits < API

    VALID_COMMIT_PARAM_NAMES = %w[
      message
      tree
      parents
      author
      committer
      name
      email
      date
    ].freeze

    REQUIRED_COMMIT_PARAMS = %w[
      message
      tree
      parents
    ].freeze

    # Get a commit
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.commits.get 'user-name', 'repo-name', 'sha'
    #
    #  commits = Github::Commits.new user: 'user-name', repo: 'repo-name'
    #  commits.get sha: '...'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :sha])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/git/commits/#{sha}", params)
    end
    alias :find :get

    # Create a commit
    #
    # = Parameters
    # * <tt>message</tt> - String of the commit message
    # * <tt>tree</tt> - String of the SHA of the tree object this commit points to
    # * <tt>parents</tt> - Array of the SHAs of the commits that were the parents of this commit. If omitted or empty, the commit will be written as a root commit. For a single parent, an array of one SHA should be provided, for a merge commit, an array of more than one should be provided.
    #
    # = Optional Parameters
    #
    # The committer section is optional and will be filled with the author data if omitted. If the author section is omitted, it will be filled in with the authenticated users information and the current date.
    #
    # * author.name - String of the name of the author of the commit
    # * author.email -  String of the email of the author of the commit
    # * author.date -  Timestamp of when this commit was authored
    # * committer.name - String of the name of the committer of the commit
    # * committer.email -  String of the email of the committer of the commit
    # * committer.date - Timestamp of when this commit was committed
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.commits.create 'user-name', 'repo-name',
    #    "message": "my commit message",
    #    "author": {
    #      "name": "Scott Chacon",
    #      "email": "schacon@gmail.com",
    #      "date": "2008-07-09T16:13:30+12:00"
    #    },
    #   "parents": [
    #      "7d1b31e74ee336d15cbd21741bc88a537ed063a0"
    #    ],
    #    "tree": "827efc6d56897b048c772eb4087f854f46256132"]
    #
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_COMMIT_PARAM_NAMES
        assert_required REQUIRED_COMMIT_PARAMS
      end
      params = arguments.params

      post_request("/repos/#{user}/#{repo}/git/commits", params)
    end

  end # GitData::Commits
end # Github
