# encoding: utf-8

module Github
  module Validations

    Github::require_all 'github_api/validations',
      'presence',
      'token',
      'format',
      'required'

    include Presence
    include Format
    include Token
    include Required

    VALID_API_KEYS = [
      'page',
      'per_page',
      'auto_pagination',
      'jsonp_callback'
    ]

  end # Validation
end # Github
