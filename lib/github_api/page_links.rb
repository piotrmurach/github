module Github
  # Determines the links in the current response link header to be used
  # to find the links to other pages of request responses. These will
  # only be present if the result set size exceeds the per page limit.
  class PageLinks
    include Github::Constants

    DELIM_LINKS = ",".freeze # :nodoc:

    # Hold the extracted values for URI from the Link header
    # for the first, last, next and previous page.
    attr_accessor :first, :last, :next, :prev

    # Parses links from executed request
    #
    def initialize(response_headers)
      link_header = response_headers[HEADER_LINK]
      if link_header
        return unless link_header =~ /(next|first|last|prev)/

        link_header.split(DELIM_LINKS).each do |link|
          if link.strip =~ /<([^>]+)>; rel=\"([^\"]+)\"/
            url_part, meta_part = $1, $2
            next if !url_part || !meta_part
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
        end
      else
        # When on the first page
        self.next = response_headers[HEADER_NEXT]
        self.last = response_headers[HEADER_LAST]
      end
    end

  end # PageLinks
end # Github
