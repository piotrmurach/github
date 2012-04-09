module Github
  module PagedRequest
    include Github::Constants

    extend self

    FIRST_PAGE = 1 # Default request page if none provided

    PER_PAGE   = 30 # Default number of items as specified by API

    NOT_FOUND  = -1 # Either page or per_page parameter not present

    class << self
      attr_accessor :page, :per_page
    end

    def default_page_size
      Github.api_client.per_page ? Github.api_client.per_page : PER_PAGE
    end

    def default_page
      Github.api_client.page ? Github.api_client.page : FIRST_PAGE
    end

    def page_request(path, params={})
      if params[PARAM_PER_PAGE] == NOT_FOUND
        params[PARAM_PER_PAGE] = default_page_size
      end
      if params[PARAM_PAGE] && params[PARAM_PAGE] == NOT_FOUND
        params[PARAM_PAGE] = default_page
      end

      Github::PagedRequest.page = params[PARAM_PAGE]
      Github::PagedRequest.per_page = params[PARAM_PER_PAGE]

      Github.api_client.get_request path, params
    end

  end # PagedRequest
end # Github
