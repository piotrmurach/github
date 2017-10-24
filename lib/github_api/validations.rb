# encoding: utf-8

require_relative 'validations/format'
require_relative 'validations/presence'
require_relative 'validations/required'
require_relative 'validations/token'

module Github
  module Validations
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
