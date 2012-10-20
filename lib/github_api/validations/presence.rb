# encoding: utf-8

module Github
  module Validations
    # A mixin to help validate presence of non-empty values
    module Presence

      # Ensure that esential arguments are present before request is made.
      #
      # == Parameters
      #  Hash/Array of arguments to be checked against nil and empty string
      #
      # == Example
      #  assert_presence_of user: '...', repo: '...'
      #  assert_presence_of user, repo
      #
      def assert_presence_of(*args)
        hash = args.last.is_a?(::Hash) ? args.pop : {}

        errors = hash.select { |key, val| val.to_s.empty? }
        raise Github::Error::Validations.new(errors) unless errors.empty?

        args.each do |arg|
          raise ArgumentError, "parameter cannot be nil" if arg.nil?
        end
      end

    end # Presence
  end # Validations
end # Github
