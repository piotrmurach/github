# encoding: utf-8

module Github
  # When you create a new GitHub repository via the API, you can specify a
  # .gitignore template to apply to the repository upon creation.
  class Client::Gitignore < API
    # List all templates available to pass as an option
    # when creating a repository.
    #
    # @see https://developer.github.com/v3/gitignore/#listing-available-templates
    #
    # @example
    #  github = Github.new
    #  github.gitignore.list
    #  github.gitignore.list { |template| ... }
    #
    # @api public
    def list(*args)
      arguments(args)

      response = get_request("/gitignore/templates", arguments.params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Get a single template
    #
    # @see https://developer.github.com/v3/gitignore/#get-a-single-template
    #
    # @example
    #  github = Github.new
    #  github.gitignore.get "template-name"
    #
    # Use the raw media type to get the raw contents.
    #
    # @examples
    #  github = Github.new
    #  github.gitignore.get "template-name", accept: 'applicatin/vnd.github.raw'
    #
    # @api public
    def get(*args)
      arguments(args, required: [:name])
      params = arguments.params

      if (media = params.delete('accept'))
        params['accept'] = media
        params['raw'] = true
      end

      get_request("/gitignore/templates/#{arguments.name}", params)
    end
    alias :find :get
  end # Client::Gitignore
end # Github
