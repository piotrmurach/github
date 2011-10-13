# encoding: utf-8

module Github
  class GitData
    module Trees

      VALID_TREE_PARAM_NAMES = %w[
        base_tree
        tree
        path
        mode
        type
        sha
        content
      ].freeze

      VALID_TREE_PARAM_VALUES = {
        'mode' => %w[ 100644 100755 040000 160000 120000 ],
        'type' => %w[ blob tree commit ]
      }

      # Get a tree
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.tree 'user-name', 'repo-name', 'sha'
      #  @github.git_data.tree 'user-name', 'repo-name', 'sha' do |file|
      #    file.path
      #  end
      #
      def tree(user_name, repo_name, sha, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _validate_presence_of sha
        _normalize_params_keys(params)

        response = if params['recursive']
          params['recursive'] = 1
          get("/repos/#{user}/#{repo}/git/trees/#{sha}", params)
        else
          get("/repos/#{user}/#{repo}/git/trees/#{sha.to_s}", params)
        end
        return response unless block_given?
        response.tree.each { |el| yield el }
      end

      # Create a tree
      #
      # The tree creation API will take nested entries as well.
      # If both a tree and a nested path modifying that tree are specified,
      # it will overwrite the contents of that tree with the new path contents
      # and write a new tree out.
      #
      # = Parameters
      # * <tt>:base_tree</tt> - optional string of the SHA1 of the tree you want to update with new data
      # * <tt>:tree</tt> - array of hash objects(of <tt>:path</tt>, <tt>:mode</tt>, <tt>:type</tt> and <tt>sha</tt>)
      # * tree.path:: String of the file referenced in the tree
      # * tree.mode:: String of the file mode - one of <tt>100644</tt> for file(blob), <tt>100755</tt> for executable (blob), <tt>040000</tt> for subdirectory (tree), <tt>160000</tt> for submodule (commit) or <tt>120000</tt> for a blob that specifies the path of a symlink
      # * tree.type:: String of <tt>blob</tt>, <tt>tree</tt>, <tt>commit</tt>
      # * tree.sha:: String of SHA1 checksum ID of the object in the tree
      # * tree.content:: String of content you want this file to have - GitHub will write this blob out and use the SHA for this entry. Use either this or <tt>tree.sha</tt>
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.create_tree 'user-name', 'repo-name',
      #    "tree" => [
      #      {
      #        "path" => "file.rb",
      #        "mode" => "100644",
      #        "type" => "blob",
      #        "sha" => "44b4fc6d56897b048c772eb4087f854f46256132"
      #      },
      #      ...
      #    ]
      #
      def create_tree(user_name=nil, repo_name=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        _filter_params_keys(VALID_TREE_PARAM_NAMES, params['tree'])
        _validate_params_values(VALID_TREE_PARAM_VALUES, params['tree'])

        post("/repos/#{user}/#{repo}/git/trees", params)
      end

    end # Trees
  end # GitData
end # Github
