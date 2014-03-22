# encoding: utf-8

require 'github_api/api/config/property'
require 'github_api/api/config/property_set'

module Github

  class API
    # A base class for constructing api configuration
    class Config

      # Defines a property on an object's class or instance
      #
      # @example
      #   class Configuration < Api::Config
      #     property :adapter, default: :net_http
      #     property :user, required: true
      #   end
      #
      # @param [Symbol] name
      #   the name of a property
      #
      # @param [#to_hash] options
      #   the extra options
      #
      # @return [self]
      #
      # @api public
      def self.property(name, options = {})
        property_set << Property.new(name, options)
        self
      end

      # Check if property is defined
      #
      # @param [Symbol] name
      #   the name to check
      #
      # @return [Boolean]
      #
      # @api public
      def self.defined?(name)
        property_set.include?(name)
      end

      class << self
        attr_reader :property_set
      end

      instance_variable_set("@property_set", PropertySet.new(self))

      def self.inherited(descendant)
        descendant.instance_variable_set('@property_set', self.property_set.dup)
      end

      def initialize(&block)
        super(&block)
        set_defaults
      end

      def property_names
        self.class.property_set.properties.map(&:name)
      end

      # Fetach all the properties and their values
      #
      # @return [Hash[Symbol]]
      #
      # @api public
      def fetch
        self.class.property_set.properties.each_with_object({}) do |property, properties|
          name = property.name
          properties[name] = send(name)
        end
      end

      # Set defaults
      #
      # @return [self]
      #
      # @api private
      def set_defaults
        self.class.property_set.properties.each do |property|
          if !!property.default
            send("#{property.name}=", property.default)
          end
        end
      end

      # Provide access to properties
      #
      # @example
      #   config.call do |config|
      #     config.adapter = :net_http
      #   end
      #
      # @return [self]
      #
      # @api private
      def call(&block)
        block.call(self) if block_given?
        self
      end
    end # Config
  end # Api
end # Github
