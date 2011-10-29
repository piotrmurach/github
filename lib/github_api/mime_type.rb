# encoding: utf-8

module Github
  module MimeType

    attr_accessor :accepts

    RESOURCE_LOOKUP = {
      :json           => 'json',
      :issue          => 'vnd.github-issue.',
      :issue_comment  => 'vnd.github-issuecomment.',
      :commit_comment => 'vnd.github-commitcomment.',
      :pull_request   => 'vnd.github-pull.',
      :pull_comment   => 'vnd.github-pullcomment.',
      :gist_comment   => 'vnd.github-gistcomment.',
      :blob           => 'vnd.github-blob.'
    }

    MIME_LOOKUP = {
      :json => 'json',
      :blob => 'raw',
      :raw  => 'raw+json',
      :text => 'text+json',
      :html => 'html+json',
      :full => 'full+json'
    }

    def parse(resource = nil, mime_type = :json)
      resource  = lookup_resource(resource) if resource
      mime_type = lookup_mime(mime_type)
      self.accepts = "application/#{resource || ''}#{mime_type}"
    end

    def lookup_resource(name)
      RESOURCE_LOOKUP.fetch(name)
    end

    def lookup_mime(name)
      MIME_LOOKUP.fetch(name)
    end

    def _normalize_name(name)
      puts "NAME: #{name}"
      case name
      when String
        name.strip.downcase.to_sym
      when Symbol
        name
      else
        raise ArgumentError, 'Provided MIME Type is not a valid or recognized entry'
      end
    end

  end # MimeType
end # Github
