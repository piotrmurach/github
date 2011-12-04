# encoding: utf-8

require 'faraday'

module Github
  class Response::Helpers < Response

    def on_complete(env)
      env[:body].extend(Github::Result)
      env[:body].instance_eval { @env = env }
    end

  end # Response::Helpers
end # Github
