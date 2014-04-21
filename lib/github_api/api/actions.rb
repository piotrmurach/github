# encoding: utf-8

module Github
  # Core class responsible for api interface operations
  class API
    # Returns all API public methods for a given class.
    def self.extend_with_actions(child_class)
      child_class.class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def self.actions
          self.new.api_methods_in(#{child_class})
        end
        def actions
          api_methods_in(#{child_class})
        end
      RUBY_EVAL
    end

    def api_methods_in(klass)
      puts "---"
      (klass.send(:instance_methods, false) - ['actions']).sort.each do |method|
        puts "|--> #{method}"
      end
      klass.included_modules.each do |mod|
        if mod.to_s =~ /#{klass}/
          puts "| \\ #{mod.to_s}"
          mod.instance_methods(false).each do |met|
            puts "|  |--> #{met}"
          end
          puts "| /"
        end
      end
      puts "---"
      nil
    end

    def append_arguments(method)
      _method = self.method(method)
      if _method.arity == 0
        args = "()"
      elsif _method.arity > 0
        args = "(few)"
      else
        args = "(else)"
      end
      args
    end
  end # API
end # Github
