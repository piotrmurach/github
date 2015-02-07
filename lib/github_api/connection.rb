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

    def default_options(options = {})
      accept = options[:headers] && options[:headers][:accept]
      {
        headers: {
          ACCEPT         =>  accept || 'application/vnd.github.v3+json,' \
                            'application/vnd.github.beta+json;q=0.5,' \
                            'application/json;q=0.1',
          ACCEPT_CHARSET => 'utf-8',
          USER_AGENT     => options[:user_agent]
        },
        ssl: options[:ssl],
        url: options[:endpoint]
      }.tap do |h|
        if type = options[:headers] && options[:headers][CONTENT_TYPE]
          h[:headers][CONTENT_TYPE] = type
        end
        h
      end
    end

    def clear_cache
      @connection = nil
    end

    def caching?
      !@connection.nil?
    end

    # Exposes middleware builder to facilitate custom stacks and easy
    # addition of new extensions such as cache adapter.
    #
    # @api public
    def stack(options = {})
      @stack ||= begin
        builder_class = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder
        builder_class.new(&Github.default_middleware(options))
      end
    end

    # Creates http connection
    #
    # Returns a Fraday::Connection object
    def connection(api, options = {})
      connection_options = default_options(options)
      clear_cache unless options.empty?
      builder = api.stack ? api.stack : stack(options.merge!(api: api))
      connection_options.merge!(builder: builder)
      connection_options.deep_merge!(options[:connection_options]) if options[:connection_options]
      if ENV['DEBUG']
        p "Connection options : \n"
        pp connection_options
      end
      @connection ||= Faraday.new(connection_options)
    end
  end # Connection
end # Github
