module Github
  module Connection
    
    def connection(options = {})
      @connection ||= begin
        conn = Faraday.new do |builder|

          builder.use Faraday::Request::JSON
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Response::Logger

          builder.use Github::Response::Mashify
          builder.use Github::Response::Jsonize

          builder.adapter adapter
        end

        conn

        conn
      end
    end

  end # Connection
end # Github

