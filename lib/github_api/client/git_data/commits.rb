# encoding: utf-8

module Github
  class Client::GitData::Commits < API

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
    # @example
    #   github = Github.new
    #   github.git_data.commits.get 'user-name', 'repo-name', 'sha'
    #
    # @example
    #   commits = Github::Commits.new user: 'user-name', repo: 'repo-name'
    #   commits.get sha: '...'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :sha])
      params = arguments.params

      get_request("/repos/#{arguments.user}/#{arguments.repo}/git/commits/#{arguments.sha}", params)
    end
    alias :find :get

    # Create a commit
    #
    # @param [Hash] params
    # @input params [String] :message
    #   The commit message
    # @input params [String] :tree
    #   String of the SHA of the tree object this commit points to
    # @input params [Array[String]] :parents
    #   Array of the SHAs of the commits that were the parents of this commit.
    #   If omitted or empty, the commit will be written as a root commit.
    #   For a single parent, an array of one SHA should be provided,
    #   for a merge commit, an array of more than one should be provided.
    #
    # Optional Parameters
    #
    # You can provide an additional commiter parameter, which is a hash
    # containing information about the committer. Or, you can provide an author
    # parameter, which is a hash containing information about the author.
    #
    # The committer section is optional and will be filled with the author
    # data if omitted. If the author section is omitted, it will be filled
    # in with the authenticated users information and the current date.
    #
    # Both the author and commiter parameters have the same keys:
    #
    # @input params [String] :name
    #   String of the name of the author (or commiter) of the commit
    # @input params [String] :email
    #   String of the email of the author (or commiter) of the commit
    # @input params [Timestamp] :date
    #   Indicates when this commit was authored (or committed).
    #   This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
    #
    # @example
    #   github = Github.new
    #   github.git_data.commits.create 'user-name', 'repo-name',
    #     message: "my commit message",
    #     author: {
    #       name: "Scott Chacon",
    #       email: "schacon@gmail.com",
    #       date: "2008-07-09T16:13:30+12:00"
    #     },
    #     parents: [
    #       "7d1b31e74ee336d15cbd21741bc88a537ed063a0"
    #     ],
    #     tree: "827efc6d56897b048c772eb4087f854f46256132"]
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_COMMIT_PARAM_NAMES
        assert_required REQUIRED_COMMIT_PARAMS
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/git/commits", arguments.params)
    end
  end # GitData::Commits
end # Github
