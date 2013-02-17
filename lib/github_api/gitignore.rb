# encoding: utf-8

module Github

  # When you create a new GitHub repository via the API, you can specify a
  # .gitignore template to apply to the repository upon creation.
  class Gitignore < API

    # Creates new Gitignore API
    def initialize(options={}, &block)
      super(options, &block)
    end

    # List all templates available to pass as an option when creating a repository.
    #
    # = Examples
    #  github = Github.new
    #  github.gitignore.list
    #  github.gitignore.list { |template| ... }
    #
    def list(*args)
      params = args.extract_options!
      normalize! params

      response = get_request("/gitignore/templates", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single template
    #
    # = Examples
    #  github = Github.new
    #  github.gitignore.get "template-name"
    #
    # Use the raw media type to get the raw contents.
    #
    # = Examples
    #  github = Github.new
    #  github.gitignore.get "template-name", mime: 'applicatin/vnd.github.raw'
    #
    def get(name, params={})
      normalize! params
      assert_presence_of name

      if (mime_type = params.delete('mime'))
        options = { :raw => true, :headers => {'Accept' => mime_type} }
      end

      get_request("/gitignore/templates/#{name}", params, options || {})
    end
    alias :find :get

  end # Gitignore
end # Github
