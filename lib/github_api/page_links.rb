module Github
  # Determines the links in the current response link header to be used
  # to find the links to other pages of request responses. These will
  # only be present if the result set size exceeds the per page limit.
  #
  # @api private
  class PageLinks
    include Github::Constants

    DELIM_LINKS = ','.freeze # :nodoc:

    # Hold the extracted values for URI from the Link header
    # for the first, last, next and previous page.
    attr_accessor :first, :last, :next, :prev

    LINK_REGEX = /<([^>]+)>; rel=\"([^\"]+)\"/

    # Parses links from executed request
    #
    # @param [Hash] response_headers
    #
    # @api private
    def initialize(response_headers)
      link_header = response_headers[HEADER_LINK]
      if link_header && link_header =~ /(next|first|last|prev)/
        extract_links(link_header)
      else
        # When on the first page
        self.next = response_headers[HEADER_NEXT]
        self.last = response_headers[HEADER_LAST]
      end
    end

    private

    def extract_links(link_header)
      link_header.split(DELIM_LINKS).each do |link|
        LINK_REGEX.match(link.strip) do |match|
          url_part, meta_part = match[1], match[2]
          next if !url_part || !meta_part
          assign_url_part(meta_part, url_part)
        end
      end
    end

    def assign_url_part(meta_part, url_part)
      case meta_part
      when META_FIRST
        self.first = url_part
      when META_LAST
        self.last = url_part
      when META_NEXT
        self.next = url_part
      when META_PREV
        self.prev = url_part
      end
    end
  end # PageLinks
end # Github
