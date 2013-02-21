# encoding: utf-8

module Github
  class GitData::References < API

    VALID_REF_PARAM_NAMES = %w[ ref sha force ].freeze

    REQUIRED_REF_PARAMS = %w[ ref sha ].freeze

    VALID_REF_PARAM_VALUES = {
      'ref' => %r{^refs\/\w+(\/\w+)*} # test fully qualified reference
    }

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
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = if (ref = params.delete('ref'))
        validate_reference ref
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
    def get(*args)
      arguments(args, :required => [:user, :repo, :ref])
      validate_reference ref
      params = arguments.params

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
    def create(*args)
      arguments(args, :required => [:user, :repo]) do
        sift VALID_REF_PARAM_NAMES
        assert_required REQUIRED_REF_PARAMS
      end
      params = arguments.params
      validate_reference params['ref']

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
    def update(*args)
      arguments(args, :required => [:user, :repo, :ref]) do
        sift VALID_REF_PARAM_NAMES
        assert_required %w[ sha ]
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
    end

    # Delete a reference
    #
    # = Examples
    #  github = Github.new
    #  github.git_data.references.delete 'user-name', 'repo-name',
    #    "ref" => "refs/heads/master",
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :ref])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/git/refs/#{ref}", params)
    end
    alias :remove :delete

  private

    def validate_reference(ref)
      refs = (ref =~ (/^(\/)?refs.*/) ? ref : "refs/#{ref}").gsub(/(\/)+/, '/')
      refs.gsub!(/^\//, '')
      unless VALID_REF_PARAM_VALUES['ref'] =~ refs
        raise ArgumentError, "Provided 'reference' is invalid"
      end
    end

  end # GitData::References
end # Github
