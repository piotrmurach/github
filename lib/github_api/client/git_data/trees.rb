# encoding: utf-8

module Github
  class Client::GitData::Trees < API

    VALID_TREE_PARAM_NAMES = %w[
      base_tree
      tree
      path
      mode
      type
      sha
      content
      url
    ].freeze

    VALID_TREE_PARAM_VALUES = {
      'mode' => %w[ 100644 100755 040000 160000 120000 ],
      'type' => %w[ blob tree commit ]
    }

    # Get a tree
    #
    # @example
    #  github = Github.new
    #  github.git_data.trees.get 'user-name', 'repo-name', 'sha'
    #  github.git_data.trees.get 'user-name', 'repo-name', 'sha' do |file|
    #    file.path
    #  end
    #
    # Get a tree recursively
    #
    # @example
    #  github = Github.new
    #  github.git_data.trees.get 'user-name', 'repo-name', 'sha', recursive: true
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :sha])
      user   = arguments.user
      repo   = arguments.repo
      sha    = arguments.sha
      params = arguments.params

      response = if params['recursive']
        params['recursive'] = 1
        get_request("/repos/#{user}/#{repo}/git/trees/#{sha}", params)
      else
        get_request("/repos/#{user}/#{repo}/git/trees/#{sha.to_s}", params)
      end
      return response unless block_given?
      response.tree.each { |el| yield el }
    end
    alias :find :get

    # Create a tree
    #
    # The tree creation API will take nested entries as well.
    # If both a tree and a nested path modifying that tree are specified,
    # it will overwrite the contents of that tree with the new path contents
    # and write a new tree out.
    #
    # @param [Hash] params
    # @input params [String] :base_tree
    #   The SHA1 of the tree you want to update with new data
    # @input params [Array[Hash]] :tree
    #   Required. Objects (of path, mode, type, and sha)
    #   specifying a tree structure
    #
    # The tree parameter takes the following keys:
    # @input tree [String] :path
    #   The file referenced in the tree
    # @input tree [String] :mode
    #   The file mode; one of 100644 for file (blob), 100755 for
    #   executable (blob), 040000 for subdirectory (tree), 160000 for
    #   submodule (commit), or 120000 for a blob that specifies
    #   the path of a symlink
    # @input tree [String] :type
    #   Either blob, tree, or commit
    # @input tree [String] :sha
    #   The SHA1 checksum ID of the object in the tree
    # @input tree [String] :content
    #   The content you want this file to have - GitHub will write
    #   this blob out and use the SHA for this entry.
    #   Use either this or <tt>tree.sha</tt>
    #
    # @example
    #  github = Github.new
    #  github.git_data.trees.create 'user-name', 'repo-name',
    #    tree: [
    #      {
    #        path: "file.rb",
    #        mode: "100644",
    #        type: "blob",
    #        sha: "44b4fc6d56897b048c772eb4087f854f46256132"
    #      },
    #      ...
    #    ]
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        assert_required %w[ tree ]
        permit VALID_TREE_PARAM_NAMES, 'tree', { recursive: true }
        assert_values VALID_TREE_PARAM_VALUES, 'tree'
      end

      post_request("/repos/#{arguments.user}/#{arguments.repo}/git/trees", arguments.params)
    end
  end # GitData::Trees
end # Github
