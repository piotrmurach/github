# encoding: utf-8

module Github
  module Validations
    extend AutoloadHelper

    autoload_all 'github_api/validations',
      :Presence => 'presence',
      :Token    => 'token',
      :Format   => 'format',
      :Required => 'required'

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
