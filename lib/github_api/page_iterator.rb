# encoding: utf-8

require 'github_api/utils/url'

module Github
  class PageIterator
    include Github::Constants
    include Github::Utils::Url
    include Github::PagedRequest

    # Query string separator
    QUERY_STR_SEP = '?'.freeze

    # Setup attribute accesor for all the link types
    ATTRIBUTES = [ META_FIRST, META_NEXT, META_PREV, META_LAST ]

    ATTRIBUTES.each do |attr|
      attr_accessor :"#{attr}_page_uri", :"#{attr}_page"
    end

    def initialize(env)
      @links = Github::PageLinks.new(env[:response_headers])
      update_page_links @links
    end

    def has_next?
      next_page == 0 || !next_page_uri.nil?
    end

    def first
      return nil unless first_page_uri
      response = page_request first_page_uri.split(QUERY_STR_SEP)[0],
                              'per_page' => parse_per_page_number(first_page_uri)
      update_page_links response.links
      response
    end

    def next
      return nil unless has_next?

      response = page_request next_page_uri.split(QUERY_STR_SEP)[0],
                                'page' => next_page,
                                'per_page'=> parse_per_page_number(next_page_uri)
      update_page_links response.links
      response
    end

    def prev
      return nil unless prev_page_uri
      response = page_request prev_page_uri.split(QUERY_STR_SEP)[0],
                              'page' => prev_page,
                              'per_page'=> parse_per_page_number(prev_page_uri)
      update_page_links response.links
      response
    end

    def last
      return nil unless last_page_uri
      response = page_request last_page_uri.split(QUERY_STR_SEP)[0],
                              'page' => last_page,
                              'per_page' => parse_per_page_number(last_page_uri)
      update_page_links response.links
      response
    end

    # Get the result for a specific page.
    def get_page(page_number)
    end

  private

    def parse_per_page_number(uri) # :nodoc:
      parse_page_params(uri, PARAM_PER_PAGE)
    end

    def parse_page_number(uri) # :nodoc:
      parse_page_params(uri, PARAM_PAGE)
    end

    # Extracts query string parameter for given name
    def parse_page_params(uri, attr) # :nodoc:
      return -1 if uri.nil? || uri.empty?
      parsed = nil
      begin
        parsed = URI.parse(uri)
      rescue URI::Error => e
        return -1
      end
      param = parse_query_for_param(parsed.query, attr)
      return -1 if param.nil? || param.empty?
      begin
        return param.to_i
      rescue ArgumentError => err
        return -1
      end
    end

    # Wholesale update of all link attributes
    def update_page_links(links) # :nodoc:
      ATTRIBUTES.each do |attr|
        self.send(:"#{attr}_page_uri=", links.send(:"#{attr}"))
        self.send(:"#{attr}_page=", parse_page_number(links.send(:"#{attr}")))
      end
    end

  end # PageIterator
end # Github
