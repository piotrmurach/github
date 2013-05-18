# encoding: utf-8

module Github
  # Request arguments handler
  class Arguments

    include Normalizer
    include ParameterFilter
    include Validations

    AUTO_PAGINATION = 'auto_pagination'.freeze

    # Parameters passed to request
    attr_reader :params

    attr_reader :remaining

    # The request api
    #
    attr_reader :api

    # Required arguments
    #
    attr_reader :required
    private :required

    # Optional arguments
    #
    attr_reader :optional
    private :optional

    # Takes api, filters and required arguments
    #
    # = Parameters
    #  :required - arguments that must be present before request is fired
    #
    def initialize(api, options={})
      normalize! options
      @api      = api
      @required = options.fetch('required', []).map(&:to_s)
      @optional = options.fetch('optional', []).map(&:to_s)
    end

    # Parse arguments to allow for flexible api calls.
    # Arguments can be part of parameters hash or be simple string arguments.
    #
    def parse(*args, &block)
      options = ParamsHash.new(args.extract_options!)
      normalize! options

      if !args.size.zero?
        parse_arguments *args
      else
        # Arguments are inside the parameters hash
        parse_options options
      end
      @params = options
      @remaining = extract_remaining(args)
      extract_pagination(options)
      yield_or_eval(&block)
      self
    end

    # Remove unkown keys from parameters hash.
    #
    # = Parameters
    #  :recursive - boolean that toggles whether nested filtering should be applied
    #
    def sift(keys, key=nil, options={})
      filter! keys, (key.nil? ? params : params[key]), options if keys.any?
      self
    end

    # Check if required keys are present inside parameters hash.
    #
    def assert_required(required)
      assert_required_keys required, params
      self
    end

    # Check if parameters match expected values.
    #
    def assert_values(values, key=nil)
      assert_valid_values values, (key.nil? ? params : params[key])
      self
    end

    private

    # Check and set all requried arguments.
    #
    def parse_arguments(*args)
      assert_presence_of *args
      required.each_with_index do |req, indx|
        api.set req, args[indx]
      end
      check_requirement!(*args)
    end

    # Find remaining arguments
    #
    def extract_remaining(args)
      args[required.size..-1]
    end

    # Fine auto_pagination parameter in options hash
    #
    def extract_pagination(options)
      if (value = options.delete(AUTO_PAGINATION))
        api.auto_pagination = value
      end
    end

    # Remove required arguments from parameters and
    # validate their presence(if not nil or empty string).
    #
    def parse_options(options)
      options.each { |key, val| remove_required(options, key, val) }
      provided_args = check_assignment!(options)
      check_requirement!(*provided_args.keys)
    end

    # Remove required argument from parameters
    #
    def remove_required(options, key, val)
      key = key.to_s
      if required.include? key
        assert_presence_of val
        options.delete key
        api.set key, val
      end
    end

    # Check if required arguments have been set on instance.
    #
    def check_assignment!(options)
      result = required.inject({}) { |hash, arg|
        if api.respond_to?(:"#{arg}") && (value = api.send(:"#{arg}"))
          hash[arg] = value
        end
        hash
      }
      assert_presence_of result
      result
    end

    # Check if required arguments are present.
    #
    def check_requirement!(*args)
      args_length     = args.length
      required_length = required.length

      if args_length < required_length
        ::Kernel.raise ArgumentError, "wrong number of arguments (#{args_length} for #{required_length})"
      end
    end

    # Evaluate block
    #
    def yield_or_eval(&block)
      return unless block
      block.arity > 0 ? yield(self) : self.instance_eval(&block)
    end

  end # Arguments
end # Github
