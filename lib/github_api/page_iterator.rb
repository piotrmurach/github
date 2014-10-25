# encoding: utf-8

require 'github_api/utils/url'
require 'uri'

module Github
  # A class responsible for requesting resources through page links
  #
  # @api private
  class PageIterator
    include Github::Constants
    include Github::Utils::Url
    include Github::PagedRequest

    # Setup attribute accesor for all the link types
    ATTRIBUTES = [META_FIRST, META_NEXT, META_PREV, META_LAST]

    DEFAULT_SHA = 'master'

    ATTRIBUTES.each do |attr|
      attr_accessor :"#{attr}_page_uri", :"#{attr}_page"
    end

    attr_reader :current_api

    def initialize(links, current_api)
      @links       = links
      @current_api = current_api
      update_page_links(@links)
    end

    def next?
      next_page == 0 || !next_page_uri.nil?
    end

    def count
      parse_query(URI(last_page_uri).query)['page'] if last_page_uri
    end

    # Perform http get request for the first resource
    #
    def first
      perform_request(first_page_uri) if first_page_uri
    end

    # Perform http get request for the next resource
    #
    def next
      perform_request(next_page_uri) if next?
    end

    # Perform http get request for the previous resource
    #
    def prev
      perform_request(prev_page_uri) if prev_page_uri
    end

    # Perform http get request for the last resource
    #
    def last
      perform_request(last_page_uri) if last_page_uri
    end

    # Returns the result for a specific page.
    #
    def get_page(page_number)
      # Find URI that we can work with, if we cannot get the first or the
      # last page URI then there is only one page.
      page_uri = first_page_uri || last_page_uri
      return nil unless page_uri

      perform_request(page_uri, page_number)
    end

    private

    def perform_request(page_uri_path, page_number = nil)
      page_uri = URI(page_uri_path)
      params = parse_query(page_uri.query)

      if page_number
        params['page'] = page_number
      elsif next_page < 1
        sha = sha(params)
        params['sha'] = sha if sha
      else
        params['page'] = parse_page_number(page_uri_path)
      end
      params['per_page'] = parse_per_page_number(page_uri_path)

      response = page_request(page_uri.path, params)
      update_page_links response.links
      response
    end

    def sha(params)
      return params['last_sha'] if params.keys.include?('last_sha')
      return DEFAULT_SHA if params.keys.include?('sha')
    end

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
      rescue URI::Error
        return -1
      end
      param = parse_query_for_param(parsed.query, attr)
      return -1 if param.nil? || param.empty?
      begin
        return param.to_i
      rescue ArgumentError
        return -1
      end
    end

    # Wholesale update of all link attributes
    def update_page_links(links) # :nodoc:
      ATTRIBUTES.each do |attr|
        send(:"#{attr}_page_uri=", links.send(:"#{attr}"))
        send(:"#{attr}_page=", parse_page_number(links.send(:"#{attr}")))
      end
    end
  end # PageIterator
end # Github
