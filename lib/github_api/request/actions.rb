# encoding: utf-8

module Github
  class Request

    # Define HTTP verbs used by API.
    module Actions

      # Perform a GET request
      #
      def get_request(path, params={}, options={})
        Request.new(:get, path, params, options).run
      end

      # Perform a PATCH request
      #
      def patch_request(path, params={}, options={})
        Request.new(:patch, path, params, options).run
      end

      # Perform a POST request
      #
      def post_request(path, params={}, options={})
        Request.new(:post, path, params, options).run
      end

      # Perform a PUT request
      #
      def put_request(path, params={}, options={})
        Request.new(:put, path, params, options).run
      end

      # Perform a DELETE request
      #
      def delete_request(path, params={}, options={})
        Request.new(:delete, path, params, options).run
      end

    end # Actions

  end # Request
end # Github
