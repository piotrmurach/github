# encoding: utf-8

module Github

  # A module that adds http get request to response pagination
  module PagedRequest
    include Github::Constants

    FIRST_PAGE = 1 # Default request page if none provided

    PER_PAGE   = 30 # Default number of items as specified by API

    NOT_FOUND  = -1 # Either page or per_page parameter not present

    # Check if current api instance has default per_page param set,
    # otherwise use global default.
    #
    def default_page_size
      current_api.per_page ? current_api.per_page : PER_PAGE
    end

    def default_page
      current_api.page ? current_api.page : FIRST_PAGE
    end

    # Perform http get request with pagination parameters
    #
    def page_request(path, params={})
      if params[PARAM_PER_PAGE] == NOT_FOUND
        params[PARAM_PER_PAGE] = default_page_size
      end
      if params[PARAM_PAGE] && params[PARAM_PAGE] == NOT_FOUND
        params[PARAM_PAGE] = default_page
      end

      current_api.get_request(path, ParamsHash.new(params))
    end

  end # PagedRequest
end # Github
