# encoding: utf-8

module Github
  module Result
    include Github::Constants

    # TODO Add result counts method to check total items looking at result links

    # Requests are limited to API v3 to 5000 per hour.
    def ratelimit_limit
      loaded? ? @env[:response_headers][RATELIMIT_LIMIT] : nil
    end

    def ratelimit_remaining
      loaded? ? @env[:response_headers][RATELIMIT_REMAINING] : nil
    end

    def cache_control
      loaded? ? @env[:response_headers][CACHE_CONTROL] : nil
    end

    def content_type
      loaded? ? @env[:response_headers][CONTENT_TYPE] : nil
    end

    def content_length
      loaded? ? @env[:response_headers][CONTENT_LENGTH] : nil
    end

    def etag
      loaded? ? @env[:response_headers][ETAG] : nil
    end

    def date
      loaded? ? @env[:response_headers][DATE] : nil
    end

    def location
      loaded? ? @env[:response_headers][LOCATION] : nil
    end

    def server
      loaded? ? @env[:response_headers][SERVER] : nil
    end

    def status
      loaded? ? @env[:status] : nil
    end

    def success?
      (200..299).include? status
    end

    # Returns raw body
    def body
      loaded? ? @env[:body] : nil
    end

    def loaded?
      !!@env
    end

    # Return page links
    def links
      @@links = Github::PageLinks.new(@env[:response_headers])
    end

    # Iterator like each for response pages. If there are no pages to
    # iterate over this method will return nothing.
    def each_page
      yield self.body
      while page_iterator.has_next?
        yield next_page
      end
    end

    # Retrives the result of the first page. Returns <tt>nil</tt> if there is
    # no first page - either because you are already on the first page
    # or there are no pages at all in the result.
    def first_page
      first_request = page_iterator.first
      self.instance_eval { @env = first_request.env } if first_request
      self.body
    end

    # Retrives the result of the next page. Returns <tt>nil</tt> if there is
    # no next page or no pages at all.
    def next_page
      next_request = page_iterator.next
      self.instance_eval { @env = next_request.env } if next_request
      self.body
    end

    # Retrives the result of the previous page. Returns <tt>nil</tt> if there is
    # no previous page or no pages at all.
    def prev_page
      prev_request = page_iterator.prev
      self.instance_eval { @env = prev_request.env } if prev_request
      self.body
    end
    alias :previous_page :prev_page

    # Retrives the result of the last page. Returns <tt>nil</tt> if there is
    # no last page - either because you are already on the last page,
    # there is only one page or there are no pages at all in the result.
    def last_page
      last_request = page_iterator.last
      self.instance_eval { @env = last_request.env } if last_request
      self.body
    end

    # Retrives a specific result for a page given page number.
    # The <tt>page_number</tt> parameter is not validate, hitting a page
    # that does not exist will return Github API error. Consequently, if
    # there is only one page, this method returns nil
    def page(page_number)
      request = page_iterator.get_page(page_number)
      self.instance_eval { @env = request.env } if request
      self.body
    end

    # Returns <tt>true</tt> if there is another page in the result set,
    # otherwise <tt>false</tt>
    def has_next_page?
      page_iterator.has_next?
    end

    # Repopulates objects for new values
    def reset
      nil
    end

  private

    # Internally used page iterator
    def page_iterator # :nodoc:
      @@page_iterator = Github::PageIterator.new(@env)
    end

  end # Result
end # Github
