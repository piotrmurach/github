# encoding: utf-8

module Github
  # A class responsible for dispatching http requests
  class Request

    # Defines HTTP verbs
    module Verbs
      # Make a head request
      #
      # @api public
      def head_request(path, params = ParamsHash.empty)
        Request.new(:head, path, self).call(current_options, params)
      end

      # Make a get request
      #
      # @api public
      def get_request(path, params = ParamsHash.empty)
        request = Request.new(:get, path, self).call(current_options, params)
        request.auto_paginate
      end

      # Make a patch request
      #
      # @api public
      def patch_request(path, params = ParamsHash.empty)
        Request.new(:patch, path, self).call(current_options, params)
      end

      # Make a post request
      #
      # @api public
      def post_request(path, params = ParamsHash.empty)
        Request.new(:post, path, self).call(current_options, params)
      end

      # Make a put request
      #
      # @api public
      def put_request(path, params = ParamsHash.empty)
        Request.new(:put, path, self).call(current_options, params)
      end

      # Make a delete request
      #
      # @api public
      def delete_request(path, params = ParamsHash.empty)
        Request.new(:delete, path, self).call(current_options, params)
      end

      # Make a options request
      #
      # @api public
      def options_request(path, params = ParamsHash.empty)
        Request.new(:options, path, self).call(current_options, params)
      end
    end # Verbs
  end # Request
end # Github
