# encoding: utf-8

module Github
  class GitData
    module References

      VALID_REF_PARAM_NAMES = %w[ ref sha force ].freeze

      VALID_REF_PARAM_VALUES = {
        'ref' => %r{^refs\/\w+\/\w+(\/\w+)*} # test fully qualified reference
      }

      # Get all references
      #
      # This will return an array of all the references on the system,
      # including things like notes and stashes if they exist on the server.
      # Anything in the namespace, not just <tt>heads</tt> and <tt>tags</tt>,
      # though that would be the most common.
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.references 'user-name', 'repo-name'
      #
      #  @github.git_data.references 'user-name', 'repo-name', 'tags'
      #
      def references(user_name, repo_name, ref=nil, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?
        _normalize_params_keys(params)

        response = if ref
          _validate_reference ref
          get("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
        else
          get("/repos/#{user}/#{repo}/git/refs", params)
        end
        return response unless block_given?
        response.each { |el| yield el }
      end
      alias :list_references :references
      alias :get_all_references :references

      # Get a reference
      #
      # The ref in the URL must be formatted as <tt>heads/branch</tt>,
      # not just branch. For example, the call to get the data for a
      # branch named <tt>sc/featureA</tt> would be formatted as
      # <tt>heads/sc/featureA</tt>
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.reference 'user-name', 'repo-name', 'reference'
      #
      def reference(user_name, repo_name, ref, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _validate_presence_of ref
        _validate_reference ref
        _normalize_params_keys params

        get("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
      end
      alias :get_reference :reference


      # Create a reference
      #
      # = Inputs
      # * <tt>:ref</tt> - String of the name of the fully qualified reference (ie: refs/heads/master). If it doesn’t start with ‘refs’ and have at least two slashes, it will be rejected.
      # * <tt>:sha</tt> - String of the SHA1 value to set this reference to
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.create_reference 'user-name', 'repo-name',
      #    "ref" => "refs/heads/master",
      #    "sha" =>  "827efc6d56897b048c772eb4087f854f46256132"
      #
      def create_reference(user_name, repo_name, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _normalize_params_keys params
        _filter_params_keys VALID_REF_PARAM_NAMES, params
        _validate_reference params['ref']

        raise ArgumentError, "Required params are: ref, sha" unless _validate_inputs(%w[ ref sha ], params)

        post("/repos/#{user}/#{repo}/git/refs", params)
      end

      # Update a reference
      #
      # = Inputs
      # * <tt>:sha</tt> - String of the SHA1 value to set this reference to
      # * <tt>:force</tt> - Boolean indicating whether to force the update or to make sure the update is a fast-forward update. The default is <tt>false</tt>, so leaving this out or setting it to false will make sure you’re not overwriting work.
      #
      # = Examples
      #  @github = Github.new
      #  @github.git_data.create_reference 'user-name', 'repo-name',
      #    "sha" =>  "827efc6d56897b048c772eb4087f854f46256132",
      #    "force" => true
      #
      def update_reference(user_name, repo_name, ref, params={})
        _update_user_repo_params(user_name, repo_name)
        _validate_user_repo_params(user, repo) unless user? && repo?

        _validate_presence_of ref
        _validate_reference ref
        _normalize_params_keys(params)
        _filter_params_keys(VALID_REF_PARAM_NAMES, params)

        raise ArgumentError, "Required params are: sha" unless _validate_inputs(%w[ sha ], params)

        patch("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
      end

    private

      def _validate_reference ref
        unless VALID_REF_PARAM_VALUES['ref'] =~ "refs/#{ref}"
          raise ArgumentError, "Provided 'reference' is invalid"
        end
      end

    end # References
  end # GitData
end # Github
