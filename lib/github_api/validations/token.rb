# encoding: utf-8

module Github
  module Validations
    module Token

      TOKEN_REQUIRED = [
        'get /user',
        'get /user/emails',
        'get /user/followers',
        'get /user/following',
        'get /user/keys',
        'get /user/repos',
        'patch /user',
        'post /user/emails',
        'post /user/keys',
        'post /user/repos'
      ]

      TOKEN_REQUIRED_REGEXP = [
        /repos\/.*\/.*\/comments/,
      ]

      # Ensures that required authentication token is present before
      # request is sent.
      #
      def validates_token_for(method, path)
        return true unless TOKEN_REQUIRED.grep("#{method} #{path}").empty?

        token_required = false
        TOKEN_REQUIRED_REGEXP.each do |regex|
          if "#{method} #{path}" =~ regex
            token_required = true
          end
        end
        return token_required
      end

    end # Token
  end # Validations
end # Github
