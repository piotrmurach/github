# encoding: utf-8

module Github
  # Specifies Http connection options
  module Connection
    extend self
    include Github::Constants

    ALLOWED_OPTIONS = [
      :headers,
      :url,
      :params,
      :request,
      :ssl
    ].freeze

    # Default requets header information
    #
    # @return [Hash[String]]
    #
    # @api private
    def default_headers
      {
        ACCEPT         => 'application/vnd.github.v3+json,' \
                          'application/vnd.github.beta+json;q=0.5,' \
                          'application/json;q=0.1',
        ACCEPT_CHARSET => 'utf-8'
      }
    end

    # Create default connection options
    #
    # @return [Hash[Symbol]]
    #   the default options
    #
    # @api private
    def default_options(options = {})
      headers = default_headers.merge(options[:headers] || {})
      headers.merge!({USER_AGENT => options[:user_agent]})
      {
        headers: headers,
        ssl: options[:ssl],
        url: options[:endpoint]
      }
    end

    # Exposes middleware builder to facilitate custom stacks and easy
    # addition of new extensions such as cache adapter.
    #
    # @api public
    def stack(options = {})
      @stack ||= begin
        builder_class = if defined?(Faraday::RackBuilder)
                          Faraday::RackBuilder
                        else
                          Faraday::Builder
                        end
        builder_class.new(&Github.default_middleware(options))
      end
    end

    # Creates http connection
    #
    # Returns a Fraday::Connection object
    def connection(api, options = {})
      connection_options = default_options(options)
      connection_options.merge!(builder: stack(options.merge!(api: api)))
      if options[:connection_options]
        connection_options.deep_merge!(options[:connection_options])
      end
      if ENV['DEBUG']
        p "Connection options : \n"
        pp connection_options
      end
      Faraday.new(connection_options)
    end
  end # Connection
end # Github
