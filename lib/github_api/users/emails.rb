# encoding: utf-8

module Github
  class Users
    module Emails

      # List email addresses for the authenticated user
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.emails
      #  @github.users.emails { |email| ... }
      #
      def emails(params={})
        _normalize_params_keys(params)
        response = get("/user/emails", params)
        return response unless block_given?
        response.each { |el| yield el }
      end

      # Add email address(es) for the authenticated user
      #
      # = Inputs
      # You can include a single email address or an array of addresses
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.add_email "octocat@github.com", "support@github.com"
      #
      def add_email(*args)
        params = _extract_parameters(args)
        _normalize_params_keys(params)
        params['data'] = [args].flatten if args
        post("/user/emails", params)
      end

      # Delete email address(es) for the authenticated user
      #
      # = Inputs
      # You can include a single email address or an array of addresses
      #
      # = Examples
      #  @github = Github.new :oauth_token => '...'
      #  @github.users.delete_email "octocat@github.com", "support@github.com"
      #
      def delete_email(*args)
        params = _extract_parameters(args)
        _normalize_params_keys(params)
        params['data'] = [args].flatten
        delete("/user/emails", params)
      end

    end # Emails
  end # Users
end # Github
