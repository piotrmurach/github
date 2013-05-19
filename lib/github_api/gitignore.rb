# encoding: utf-8

module Github

  # When you create a new GitHub repository via the API, you can specify a
  # .gitignore template to apply to the repository upon creation.
  class Gitignore < API

    # List all templates available to pass as an option when creating a repository.
    #
    # = Examples
    #  github = Github.new
    #  github.gitignore.list
    #  github.gitignore.list { |template| ... }
    #
    def list(*args)
      arguments(args)

      response = get_request("/gitignore/templates", arguments.params)
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
    #  github.gitignore.get "template-name", accept: 'applicatin/vnd.github.raw'
    #
    def get(*args)
      params = arguments(args, :required => [:name]).params

      if (media = params.delete('accept'))
        params['accept'] = media
        params['raw'] = true
      end

      get_request("/gitignore/templates/#{name}", params)
    end
    alias :find :get

  end # Gitignore
end # Github
