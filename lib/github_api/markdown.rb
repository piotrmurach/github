# encoding: utf-8

module Github
  class Markdown < API

    # Creates new Markdown API
    def initialize(options = {})
      super(options)
    end

    # Render an arbritrary Markdown document
    #
    # = Parameters
    #  <tt>:text</tt> - Required string - The Markdown text to render
    #  <tt>:mode<tt> - Optional string - The rendering mode
    #    * <tt>markdown</tt> to render a document as plain Markdown, just
    #                        like README files are rendered.
    #    * <tt>gfm</tt> to render a document as user-content, e.g. like user
    #      comments or issues are rendered. In GFM mode, hard line breaks are
    #      always taken into account, and issue and user mentions are
    #      linked accordingly.
    #  <tt>:context<tt> - Optional string - The repository context, only taken
    #                     into account when rendering as <tt>gfm</tt>
    #
    # = Examples
    #  github = Github.new
    #  github.markdown.render
    #    "text": "Hello world github/linguist#1 **cool**, and #1!",
    #    "mode": "gfm",
    #    "context": "github/gollum"
    #
    def render(*args)
      params = args.extract_options!
      normalize! params

      assert_required_keys ['text'], params
      post_request("markdown", params, :raw => true)
    end


    # Render a Markdown document in raw mode
    #
    # = Input
    #  The raw API it not JSON-based. It takes a Markdown document as plaintext
    #  <tt>text/plain</tt> or <tt>text/x-markdown</tt> and renders it as plain
    #  Markdown without a repository context (just like a README.md file is
    #  rendered – this is the simplest way to preview a readme online)
    #
    # = Examples
    #  github = Github.new
    #  github.markdown.render_raw "Hello github/linguist#1 **cool**, and #1!",
    #    "mime": "text/plain",
    #
    def render_raw(*args)
      params = args.extract_options!
      normalize! params
      mime_type, params['data'] = params['mime'], args.shift

      post_request("markdown/raw", params, :raw => true,
                      :headers => {'Content-Type' => mime_type || 'text/plain'})
    end

  end # Markdown
end # Github
