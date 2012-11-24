# encoding: utf-8

module Github
  # Request arguments handler
  class Arguments

    include Normalizer
    include ParameterFilter
    include Validations

    # Parameters passed to request
    attr_reader :params

    # The request api
    #
    attr_reader :api

    # Required arguments
    #
    attr_reader :required
    private :required

    # Takes api, filters and required arguments
    #
    # = Parameters
    #  :required - arguments that must be present before request is fired
    #
    def initialize(api, options={})
      normalize! options
      @api      = api
      @required = options.fetch('required', []).map(&:to_s)
    end

    # Parse arguments to allow for flexible api calls.
    # Arguments can be part of parameters hash or be simple string arguments.
    #
    def parse(*args, &block)
      options = args.extract_options!
      normalize! options

      if args.any?
        parse_arguments *args
      else
        # Arguments are inside the parameters hash
        parse_options options
      end
      @params = options
      yield_or_eval(&block)
      self
    end

    # Remove unkown parameters.
    #
    # = Parameters
    #  :recursive - boolean that toggles whether nested filtering should be applied
    #
    def sift(keys, options={})
      filter! keys, params, options if keys.any?
      self
    end

    # Check if required parameters are present.
    #
    def assert_required(required)
      assert_required_keys required, params
      self
    end

    private

    # Check and set all requried arguments.
    #
    def parse_arguments(*args)
      assert_presence_of *args
      args.each_with_index do |arg, indx|
        api.set required[indx], arg
      end
      check_requirement!(*args)
    end

    # Remove required arguments from parameters and
    # validate their presence(if not nil or empty string).
    #
    def parse_options(options)
      options.each { |key, val| remove_required options, key, val }
      check_assignment!(options)
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
      assert_presence_of required.inject({}) { |hash, arg|
        api.set(:"#{arg}", '') unless api.respond_to? :"#{arg}"
        hash[arg] = api.send(:"#{arg}")
        hash
      }
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
