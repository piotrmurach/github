# encoding: utf-8
require 'set'

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

        # Access property by name
        #
        # @api public
        def [](name)
          @map[name]
        end
        alias_method :fetch, :[]

        # Set property value by name
        #
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

        # Convert properties to a hash of property names and
        # corresponding values
        #
        # @api public
        def to_hash
          properties.each_with_object({}) do |property, props|
            name = property.name
            props[name] = self[name]
          end
        end

        # Check if properties exist
        #
        # @api public
        def empty?
          @map.empty?
        end

        # @api private
        def define_reader_method(property, method_name, visibility)
          property_set = self
          parent.send(:define_method, method_name) { property_set[property.name] }
          parent.send(visibility, method_name)
        end

        # @api private
        def define_writer_method(property, method_name, visibility)
          property_set = self
          parent.send(:define_method, method_name) do |value|
            property_set[property.name]= value
          end
          parent.send(visibility, method_name)
        end
      end # PropertySet
    end # Config
  end # Api
end # Github
