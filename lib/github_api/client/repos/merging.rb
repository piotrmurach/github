# encoding: utf-8

module Github
  # The Repo Merging API supports merging branches in a repository. This
  # accomplishes essentially the same thing as merging one branch into another
  # in a local repository and then pushing to GitHub.
  class Client::Repos::Merging < API

    VALID_MERGE_PARAM_NAMES = %w[
      base
      head
      commit_message
    ].freeze # :nodoc:

    REQUIRED_MERGE_PARAMS = %w[ base head ].freeze # :nodoc:

    # Perform a merge
    #
    # @param [Hash] params
    # @input params [String] :base
    #   Required. The name of the base branch that the head will be merged into.
    # @input params [String] :head
    #   Required. The head to merge. This can be a branch name or a commit SHA1.
    # @input params [String] :commit_message
    #   Commit message to use for the merge commit.
    #   If omitted, a default message will be used.
    #
    # @example
    #   github = Github.new
    #   github.repos.merging.merge 'user', 'repo',
    #     base: "master",
    #     head: "cool_feature",
    #     commit_message: "Shipped cool_feature!"
    #
    # @api public
    def merge(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_MERGE_PARAM_NAMES
        assert_required REQUIRED_MERGE_PARAMS
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/merges", arguments.params)
    end
  end # Client::Repos::Merging
end # Github
