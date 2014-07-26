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
        self.property_set << Property.new(name, options)
        update_subclasses(name, options)
        self
      end

      def self.update_subclasses(name, options)
        if defined?(@subclasses) && @subclasses
          @subclasses.each { |klass| klass.property(name, options) }
        end
      end

      # Check if property is defined
      #
      # @param [Symbol] name
      #   the name to check
      #
      # @return [Boolean]
      #
      # @api public
      def self.property?(name)
        property_set.include?(name)
      end

      class << self
        attr_reader :property_set
      end

      instance_variable_set("@property_set", PropertySet.new(self))

      def self.inherited(descendant)
        super
        (@subclasses ||= Set.new) << descendant
        descendant.instance_variable_set('@property_set',
          PropertySet.new(descendant, self.property_set.properties.dup))
      end

      def initialize(&block)
        super(&block)
      end

      def property_names
        self.class.property_set.properties.map(&:name)
      end

      def self.property_names
        property_set.properties.map(&:name)
      end

      # Fetach all the properties and their values
      #
      # @return [Hash[Symbol]]
      #
      # @api public
      def fetch(value = nil)
        if value
          self.class.property_set[value]
        else
          self.class.property_set.to_hash
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
