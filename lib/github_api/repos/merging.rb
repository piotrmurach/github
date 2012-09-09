# encoding: utf-8

module Github
  # The Repo Merging API supports merging branches in a repository. This
  # accomplishes essentially the same thing as merging one branch into another
  # in a local repository and then pushing to GitHub.
  class Repos::Merging < API

    VALID_MERGE_PARAM_NAMES = %w[
      base
      head
      commit_message
    ].freeze # :nodoc:

    REQUIRED_MERGE_PARAMS = %w[ base head ].freeze # :nodoc:

    # Perform a merge
    #
    # = Inputs
    # * <tt>:base</tt> - Required String - The name of the base branch that the head will be merged into.
    # * <tt>:head</tt> - Required String - The head to merge. This can be a branch name or a commit SHA1.
    # * <tt>:commit_message</tt> - Optional String - Commit message to use for the merge commit. If omitted, a default message will be used.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.merging.merge 'user', 'repo',
    #    "base": "master",
    #    "head": "cool_feature",
    #    "commit_message": "Shipped cool_feature!"
    #
    def merge(user_name, repo_name, params={})
      normalize! params
      filter! VALID_MERGE_PARAM_NAMES, params
      assert_required_keys REQUIRED_MERGE_PARAMS, params

      post_request("/repos/#{user_name}/#{repo_name}/merges", params)
    end

  end # Repos::Merging
end # Github
