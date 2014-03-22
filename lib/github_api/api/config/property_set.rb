# encoding: utf-8

module Github
  class API
    class Config

      # Class responsible for storing configuration properties
      class PropertySet
        include Enumerable

        attr_reader :parent

        attr_reader :properties

        # Initialize an PropertySet
        #
        # @param [Object] parent
        # @param [Set] properties
        #
        # @return [undefined]
        #
        # @api private
        def initialize(parent = nil, properties = Set.new)
          @parent = parent
          @properties = properties
          @map = {}
          reset
        end

        # Iterate over properties
        #
        # @yield [property]
        #
        # @yieldparam [Property] property
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?
          @map.each { |name, property| yield property if name.is_a?(Symbol) }
          self
        end

        # Adds property to the set
        #
        # @example
        #   properties_set << property
        #
        # @param [Property] property
        #
        # @return [self]
        #
        # @api public
        def <<(property)
          properties << property
          update_map(property.name, property.default)
          property.define_accessor_methods(self)
          self
        end

        # @api public
        def [](name)
          @map[name]
        end

        # @api public
        def []=(name, property)
          update_map(name, property)
        end

        # Update map with index
        #
        # @api private
        def update_map(name, property)
          @map[name.to_sym] = @map[name.to_s.freeze] = property
        end

        # @api private
        def define_reader_method(property, method_name, visibility)
          return if parent.instance_methods.map(&:to_s).include?("#{property.name}")
          property_set = self
          parent.send(:define_method, method_name) { property_set[property.name] }
          parent.send(visibility, method_name)
        end

        # @api private
        def define_writer_method(property, method_name, visibility)
          return if parent.instance_methods.map(&:to_s).include?("#{property.name}=")
          property_set = self
          parent.send(:define_method, method_name) do |value|
            property_set[property.name]= value
          end
          parent.send(visibility, method_name)
        end

        def reset
        end

      end # PropertySet
    end # Config
  end # Api
end # Github
