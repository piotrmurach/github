# encoding: utf-8

module Github
  class GitData::References < API

    VALID_REF_PARAM_NAMES = %w[ ref sha force ].freeze

    VALID_REF_PARAM_VALUES = {
      'ref' => %r{^refs\/\w+(\/\w+)*} # test fully qualified reference
    }

    # Creates new GitData::References API
    def initialize(options = {})
      super(options)
    end

    # Get all references
    #
    # This will return an array of all the references on the system,
    # including things like notes and stashes if they exist on the server.
    # Anything in the namespace, not just <tt>heads</tt> and <tt>tags</tt>,
    # though that would be the most common.
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.references.list 'user-name', 'repo-name'
    #
    #  github.git_data.references.list 'user-name', 'repo-name', ref:'tags'
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = if params['ref']
        ref = params.delete('ref')
        _validate_reference ref
        get_request("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
      else
        get_request("/repos/#{user}/#{repo}/git/refs", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a reference
    #
    # The ref in the URL must be formatted as <tt>heads/branch</tt>,
    # not just branch. For example, the call to get the data for a
    # branch named <tt>sc/featureA</tt> would be formatted as
    # <tt>heads/sc/featureA</tt>
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.references.get 'user-name', 'repo-name', 'heads/branch'
    #
    def get(user_name, repo_name, ref, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _validate_presence_of ref
      _validate_reference ref
      normalize! params

      get_request("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
    end
    alias :find :get


    # Create a reference
    #
    # = Inputs
    # * <tt>:ref</tt> - String of the name of the fully qualified reference (ie: refs/heads/master). If it doesn’t start with ‘refs’ and have at least two slashes, it will be rejected.
    # * <tt>:sha</tt> - String of the SHA1 value to set this reference to
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.references.create 'user-name', 'repo-name',
    #    "ref" => "refs/heads/master",
    #    "sha" =>  "827efc6d56897b048c772eb4087f854f46256132"
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      normalize! params
      filter! VALID_REF_PARAM_NAMES, params
      _validate_presence_of params['ref']
      _validate_reference params['ref']
      assert_required_keys(%w[ ref sha ], params)

      post_request("/repos/#{user}/#{repo}/git/refs", params)
    end

    # Update a reference
    #
    # = Inputs
    # * <tt>:sha</tt> - String of the SHA1 value to set this reference to
    # * <tt>:force</tt> - Boolean indicating whether to force the update or to make sure the update is a fast-forward update. The default is <tt>false</tt>, so leaving this out or setting it to false will make sure you’re not overwriting work.
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.references.update 'user-name', 'repo-name', 'heads/master',
    #    "sha" =>  "827efc6d56897b048c772eb4087f854f46256132",
    #    "force" => true
    #
    def update(user_name, repo_name, ref, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?

      _validate_presence_of ref
      _validate_reference ref
      normalize! params
      filter! VALID_REF_PARAM_NAMES, params
      assert_required_keys(%w[ sha ], params)

      patch_request("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
    end

    # Delete a reference
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.references.delete 'user-name', 'repo-name',
    #    "ref" => "refs/heads/master",
    #
    def delete(user_name, repo_name, ref, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params
      _validate_presence_of ref

      delete_request("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
    end
    alias :remove :delete

  private

    def _validate_reference ref
      refs = ref.index('ref') ? ref : "refs/#{ref}"
      unless VALID_REF_PARAM_VALUES['ref'] =~ refs
        raise ArgumentError, "Provided 'reference' is invalid"
      end
    end

  end # GitData::References
end # Github
