# encoding: utf-8

module Github
  class API
    # A class responsible for handilng request arguments
    class Arguments
      include Normalizer
      include ParameterFilter
      include Validations

      AUTO_PAGINATION = 'auto_pagination'.freeze

      # Parameters passed to request
      attr_reader :params

      # The remaining unparsed arguments
      attr_reader :remaining

      # The request api
      attr_reader :api

      # Initialize an Arguments
      #
      # @param [Hash] options
      #
      # @option options [Array[String]] :required
      #   arguments that must be present before request is fired
      #
      # @option options [Github::API] :api
      #   the reference to the current api
      #
      # @api public
      def initialize(options = {}, &block)
        normalize! options

        @api      = options.fetch('api')
        @required = options.fetch('required', []).map(&:to_s)
        @optional = options.fetch('optional', []).map(&:to_s)
        @assigns  = {}

        yield_or_eval(&block)
      end

      # Specify required attribute(s)
      #
      # @api public
      def require(*attrs, &block)
        attrs_clone = attrs.clone
        @required = Array(attrs_clone)
        self
      end
      alias :required :require

      # Specify optional attribute(s)
      #
      # @api public
      def optional(*attrs, &block)
      end

      # Hash like access to request arguments
      #
      # @param [String, Symbol] property
      #   the property name
      #
      # @api public
      def [](property)
        @assigns[property.to_s]
      end

      def []=(property, value)
        @assigns[property.to_s] = value
      end

      def method_missing(method_name, *args, &block)
        if @assigns.key?(method_name.to_s)
          self[method_name]
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @assigns.key?(method_name) || super
      end

      # Parse arguments to allow for flexible api calls
      #
      # Arguments can be part of parameters hash or be simple string arguments.
      #
      # @api public
      def parse(*args, &block)
        options = ParamsHash.new(args.extract_options!)
        normalize! options

        if args.size.zero?  # Arguments are inside the parameters hash
          parse_hash(options)
        else
          parse_array(*args)
        end
        @params    = options
        @remaining = args[@required.size..-1]
        extract_pagination(options)

        yield_or_eval(&block)
        self
      end

      # Remove unknown keys from parameters hash.
      #
      # = Parameters
      #  :recursive - boolean that toggles whether nested filtering should be applied
      #
      def permit(keys, key=nil, options={})
        filter! keys, (key.nil? ? params : params[key]), options if keys.any?
        self
      end

      # Check if required keys are present inside parameters hash.
      #
      # @api public
      def assert_required(*required)
        assert_required_keys(required, params)
        self
      end

      # Check if parameters match expected values.
      #
      # @api public
      def assert_values(values, key=nil)
        assert_valid_values values, (key.nil? ? params : params[key])
        self
      end

      private

      # Parse array arguments and assign in order to required properties
      #
      # @param [Array[Object]] args
      #
      # @raise ArgumentError
      #
      # @return [nil]
      #
      # @api public
      def parse_array(*args)
        assert_presence_of(*args)
        @required.each_with_index do |req, indx|
          @assigns[req] = args[indx]
        end
        check_requirement!(*args)
      end

      # Remove required arguments from parameters and
      # validate their presence(if not nil or empty string).
      #
      # @param [Hash[String]] options
      #
      # @return [nil]
      #
      # @api private
      def parse_hash(options)
        options.each { |key, val| remove_required(options, key, val) }
        hash = update_required_from_global
        check_requirement!(*hash.keys)
      end

      # Remove required property from hash
      #
      # @param [Hash[String]] options
      #   the options to check
      #
      # @param [String] key
      #   the key to remove
      #
      # @param [String] val
      #   the value to assign
      #
      # @api private
      def remove_required(options, key, val)
        if @required.include?(key.to_s)
          assert_presence_of(val)
          options.delete(key)
          @assigns[key.to_s] = val
        end
      end

      # Update required property from globals if not present
      #
      # @return [Hash[String]]
      #
      # @api private
      def update_required_from_global
        @required.reduce({}) do |hash, property|
          if @assigns.key?(property)
            hash[property] = self[property]
          elsif api_property?(property)
            hash[property] = api.send(:"#{property}")
            self[property] = hash[property]
          end
          hash
        end
      end

      # Check if api has non-empty property
      #
      # @param [String] property
      #   the property to check
      #
      # @return [Boolean]
      #
      # @api private
      def api_property?(property)
        api.respond_to?(:"#{property}") && api.send(:"#{property}")
      end

      # Check if required arguments are present.
      #
      #
      def check_requirement!(*args)
        args_length     = args.length
        required_length = @required.length

        if args_length < required_length
          raise ArgumentError, "Wrong number of arguments " \
            "(#{args_length} for #{required_length}). " \
            "Expected `#{@required.join(', ')}` as required arguments, " \
            "but got `#{args.join(", ")}`."
        end
      end

      # Find auto_pagination parameter in options hash
      #
      def extract_pagination(options)
        if (value = options.delete(AUTO_PAGINATION))
          api.auto_pagination = value
        end
      end

      # Evaluate a block
      #
      # @api privte
      def yield_or_eval(&block)
        return unless block
        block.arity > 0 ? yield(self) : instance_eval(&block)
      end
    end # Arguments
  end # Api
end # Github
