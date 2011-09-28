module Github
  module Connection
    
    # Available resources 
    RESOURCES = {
      :issue         => 'vnd.github-issue.',
      :issuecomment  => 'vnd.github-issuecomment.',
      :commitcomment => 'vnd.github-commitcomment',
      :pull          => 'vnd.github-pull.',
      :pullcomment   => 'vnd.github-pullcomment.',
      :gistcomment   => 'vnd.github-gistcomment.'
    }

    # Mime types used by resources
    RESOURCE_MIME_TYPES = {
      :raw  => 'raw+json',
      :text => 'text+json',
      :html => 'html+json',
      :full => 'html+full'
    }

    BLOB_MIME_TYPES = {
      :raw => 'vnd.github-blob.raw',
      :json => 'json'
    }

    def default_faraday_options(format, resource=nil)
      {
        :headers => {
          'Accept' => "application/#{resource}#{format}",
          'User-Agent' => user_agent
        },
        :ssl => { :verify => false }
      }
    end
    
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

