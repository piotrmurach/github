# encoding: utf-8

module Github
  class API
    class Config

      # Property objects provide an interface for configuration options
      class Property

        attr_reader :name
        attr_reader :default
        attr_reader :required

        def initialize(name, options)
          @name = name
          @default = options.fetch(:default, nil)
          @required = options.fetch(:required, nil)
          @options = options
        end

        # @api private
        def define_accessor_methods(properties)
          properties.define_reader_method(self, self.name, :public)
          properties.define_writer_method(self, "#{self.name}=", :public)
        end
      end # Property

    end # Config
  end # Api
end # Github
