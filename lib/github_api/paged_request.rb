module Github
  module PagedRequest
    include Github::Constants

    extend self

    FIRST_PAGE = 1

    PER_PAGE = 25

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
      params[PARAM_PER_PAGE] = default_page_size unless params[PARAM_PER_PAGE]
      params[PARAM_PAGE] = default_page unless params[PARAM_PAGE]

      Github::PagedRequest.page = params[PARAM_PAGE]
      Github::PagedRequest.per_page = params[PARAM_PER_PAGE]

      Github.api_client.get path, params
    end

  end # PagedRequest
end # Github
