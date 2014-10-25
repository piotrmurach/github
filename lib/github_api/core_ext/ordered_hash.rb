# encoding: utf-8

module Github
  module CoreExt #:nodoc:

    if RUBY_VERSION >= '1.9'
      class OrderedHash < ::Hash; end
    else
      class OrderedHash < ::Hash
        attr_accessor :order

        class << self
          def [](*args)
            hsh = OrderedHash.new
            if Hash == args[0]
              hsh.replace args[0]
            elsif (args.size % 2) != 0
              pp args if ENV['DEBUG']
              raise ArgumentError, "odd number of elements for Hash"
            else
              0.step(args.size - 1, 2) do |a|
                b = a + 1
                hsh[args[a]] = args[b]
              end
            end
            hsh
          end
        end

        def initialize(*args, &block)
          super
          @order = []
        end

        def []=(key, value)
          @order.push key unless member?(key)
          super key, value
        end

        def ==(hsh2)
          return false if @order != hsh2.order
          super hsh2
        end

        def clear
          @order = []
          super
        end

        def delete(key)
          @order.delete key
          super
        end

        def each_key
          @order.each { |k| yield k }
          self
        end

        def each_value
          @order.each { |k| yield self[k] }
          self
        end

        def each
          @order.each { |k| yield k, self[k] }
          self
        end
        alias :each_pair :each

        def delete_if
          @order.clone.each { |k| delete k if yield }
          self
        end

        def values
          ary = []
          @order.each { |k| ary.push self[k] }
          ary
        end

        def keys
          @order
        end

        def replace(hsh2)
          @order = hsh2.keys
          super hsh2
        end

        def shift
          key = @order.first
          key ? [key, delete(key)] : super
        end

        def class
          Hash
        end

        def __class__
          OrderedHash
        end
      end # OrderedHash
    end

  end # CoreExt
end # Github
