# encoding: utf-8

module Github
  class Client::GitData::References < API

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
    # @example
    #  github = Github.new
    #  github.git_data.references.list 'user-name', 'repo-name'
    #
    # @example
    #  github.git_data.references.list 'user-name', 'repo-name', ref:'tags'
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo])
      params = arguments.params
      user = arguments.user
      repo = arguments.repo

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
    # branch named sc/featureA would be formatted as heads/sc/featureA
    #
    # @example
    #  github = Github.new
    #  github.git_data.references.get 'user-name', 'repo-name', 'heads/branch'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:user, :repo, :ref])
      validate_reference arguments.ref
      params = arguments.params

      get_request("/repos/#{arguments.user}/#{arguments.repo}/git/refs/#{arguments.ref}", params)
    end
    alias :find :get

    # Create a reference
    #
    # @param [Hash] params
    # @input params [String] :ref
    #   The name of the fully qualified reference (ie: refs/heads/master).
    #   If it doesn’t start with ‘refs’ and have at least two slashes,
    #   it will be rejected.
    # @input params [String] :sha
    #   The SHA1 value to set this reference to
    #
    # @example
    #  github = Github.new
    #  github.git_data.references.create 'user-name', 'repo-name',
    #    ref: "refs/heads/master",
    #    sha:  "827efc6d56897b048c772eb4087f854f46256132"
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo]) do
        permit VALID_REF_PARAM_NAMES
        assert_required REQUIRED_REF_PARAMS
      end
      params = arguments.params
      validate_reference params['ref']

      post_request("/repos/#{arguments.user}/#{arguments.repo}/git/refs", params)
    end

    # Update a reference
    #
    # @param [Hash] params
    # @input params [String] :sha
    #   The SHA1 value to set this reference to
    # @input params [Boolean] :force
    #   Indicates whether to force the update or to make sure the update
    #   is a fast-forward update. Leaving this out or setting it to false
    #   will make sure you’re not overwriting work. Default: false
    #
    # @example
    #  github = Github.new
    #  github.git_data.references.update 'user-name', 'repo-name', 'heads/master',
    #    sha:  "827efc6d56897b048c772eb4087f854f46256132",
    #    force: true
    #
    # @api public
    def update(*args)
      arguments(args, required: [:user, :repo, :ref]) do
        permit VALID_REF_PARAM_NAMES
        assert_required %w[ sha ]
      end

      patch_request("/repos/#{arguments.user}/#{arguments.repo}/git/refs/#{arguments.ref}", arguments.params)
    end

    # Delete a reference
    #
    # @example
    #  github = Github.new
    #  github.git_data.references.delete 'user-name', 'repo-name',
    #    "heads/master"
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :ref])
      params = arguments.params

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/git/refs/#{arguments.ref}", params)
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
