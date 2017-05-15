# encoding: utf-8

module Github
  # A class responsible for dispatching http requests
  class Request

    # Defines HTTP verbs
    module Verbs
      # Make a head request
      #
      # @api public
      #
      REDIRECT_STATUS_CODES = [301, 302, 307]
      def head_request(path, params = ParamsHash.empty)
        response = Request.new(:head, path, self).call(current_options, params)
        response = Request.new(:head, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
      end

      # Make a get request
      #
      # @api public
      def get_request(path, params = ParamsHash.empty)
        response = Request.new(:get, path, self).call(current_options, params)
        response = Request.new(:get, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
        response.auto_paginate
      end

      # Make a patch request
      #
      # @api public
      def patch_request(path, params = ParamsHash.empty)
        response = Request.new(:patch, path, self).call(current_options, params)
        response = Request.new(:patch, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
      end

      # Make a post request
      #
      # @api public
      def post_request(path, params = ParamsHash.empty)
        response = Request.new(:post, path, self).call(current_options, params)
        response = Request.new(:post, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
      end

      # Make a put request
      #
      # @api public
      def put_request(path, params = ParamsHash.empty)
        response = Request.new(:put, path, self).call(current_options, params)
        response = Request.new(:put, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
      end

      # Make a delete request
      #
      # @api public
      def delete_request(path, params = ParamsHash.empty)
        response = Request.new(:delete, path, self).call(current_options, params)
        response = Request.new(:delete, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
      end

      # Make a options request
      #
      # @api public
      def options_request(path, params = ParamsHash.empty)
        response = Request.new(:options, path, self).call(current_options, params)
        response = Request.new(:options, response.env.response_headers["location"], self).
          call(current_options, params) if REDIRECT_STATUS_CODES.include?response.status
        response = ResponseWrapper.new(response, self)
      end
    end # Verbs
  end # Request
end # Github
