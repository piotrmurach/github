# encoding: utf-8

module Github
  # Responsible for providing inspection of api methods
  class API
    # Returns all API public methods for a given class.
    #
    # @return [nil]
    #
    # @api public
    def self.extend_with_actions(child_class)
      return unless child_class.is_a?(Class)
      return if child_class.name.nil? # Skip anonymous classes

      child_class.class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def self.actions
          self.new.actions
        end

        def actions
          api_methods_in(#{child_class}) + module_methods_in(#{child_class})
        end
      RUBY_EVAL
    end

    # Finds api methods in a class
    #
    # @param [Class] klass
    #   The klass to inspect for methods.
    #
    # @api private
    def api_methods_in(klass)
      methods = klass.send(:instance_methods, false) - [:actions]
      methods.sort.each_with_object([]) do |method_name, accumulator|
        unless method_name.to_s.include?('with') ||
               method_name.to_s.include?('without')
          accumulator << method_name
        end
        accumulator
      end
    end

    # Finds methods included through class modules
    #
    # @param [Class] klass
    #   The klass to inspect for methods.
    #
    # @api private
    def module_methods_in(klass)
      klass.included_modules.each_with_object([]) do |mod, accumulator|
        if mod.to_s =~ /#{klass}/
          mod.instance_methods(false).each do |method|
            accumulator << method
          end
        end
        accumulator
      end
    end
  end # API
end # Github
