# encoding: utf-8

module Github
  class Repos::Comments < API

    REQUIRED_COMMENT_OPTIONS = %w[ body ].freeze

    VALID_COMMENT_OPTIONS = %w[
      body
      line
      path
      position
    ].freeze

    # List commit comments for a repository
    #
    # = Examples
    #  github = Github.new
    #  github.repos.comments.list 'user-name', 'repo-name'
    #  github.repos.comments.list 'user-name', 'repo-name' { |com| ... }
    #
    # List comments for a single commit
    #
    # = Examples
    #  github.repos.comments.list 'user-name', 'repo-name',
    #   :sha => '6dcb09b5b57875f334f61aebed695e2e4193db5e'
    #
    def list(*args)
      arguments(args, :required => [:user, :repo])
      params = arguments.params

      response = if (sha = params.delete('sha'))
        get_request("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
      else
        get_request("/repos/#{user}/#{repo}/comments", params)
      end
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Gets a single commit comment
    #
    # = Examples
    #  github = Github.new
    #  github.repos.comments.get 'user-name', 'repo-name', 'comment-id'
    #
    def get(*args)
      arguments(args, :required => [:user, :repo, :comment_id])
      params = arguments.params

      get_request("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
    end
    alias :find :get

    # Creates a commit comment
    #
    # = Inputs
    # * <tt>:body</tt> - Required string.
    # * <tt>:comment_id</tt> - Required string - Sha of the commit to comment on.
    # * <tt>:line</tt> - Required number - Line number in the file to comment on.
    # * <tt>:path</tt> - Required string - Relative path of the file to comment on.
    # * <tt>:position</tt> - Required number - Line index in the diff to comment on.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.comments.create 'user-name', 'repo-name', 'sha-key', 
    #    "body" => "Nice change",
    #    "commit_id" => "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    #    "line" => 1,
    #    "path" =>  "file1.txt",
    #    "position" =>  4
    #
    def create(*args)
      arguments(args, :required => [:user, :repo, :sha]) do
        sift VALID_COMMENT_OPTIONS
        assert_required REQUIRED_COMMENT_OPTIONS
      end
      params = arguments.params

      post_request("/repos/#{user}/#{repo}/commits/#{sha}/comments", params)
    end

    # Update a commit comment
    #
    # = Inputs
    # * <tt>:body</tt> - Required string.
    #
    # = Examples
    #  github = Github.new
    #  github.repos.comments.update 'user-name', 'repo-name',
    #    'comment-id', "body" => "Nice change"
    #
    def update(*args)
      arguments(args, :required => [:user, :repo, :comment_id]) do
        assert_required REQUIRED_COMMENT_OPTIONS
      end
      params = arguments.params

      patch_request("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
    end

    # Deletes a commit comment
    #
    # = Examples
    #  github = Github.new
    #  github.repos.comments.delete 'user-name', 'repo-name', 'comment-id'
    #
    def delete(*args)
      arguments(args, :required => [:user, :repo, :comment_id])
      params = arguments.params

      delete_request("/repos/#{user}/#{repo}/comments/#{comment_id}", params)
    end

  end # Repos::Comments
end # Github
