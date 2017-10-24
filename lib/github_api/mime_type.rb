# encoding: utf-8

module Github
  module MimeType

    MEDIA_LOOKUP = {
      'json' => 'json',
      'blob' => 'raw',
      'raw'  => 'raw+json',
      'text' => 'text+json',
      'html' => 'html+json',
      'full' => 'full+json'
    }

    # Parse media type param
    #
    def parse(media)
      version = 'v3'
      media.sub!(/^[.]*|[.]*$/,"")
      media = media.include?('+') ? media.split('+')[0] : media
      version, media = media.split('.') if media.include?('.')
      media_type = lookup_media(media)
      "application/vnd.github.#{version}.#{media_type}"
    end

    def lookup_media(name)
      MEDIA_LOOKUP.fetch(name) do
        raise ArgumentError, "Provided Media Type #{name} is not valid"
      end
    end

  end # MimeType
end # Github
