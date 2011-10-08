# encoding: utf-8

    class Hash
      def extractable_options?
        instance_of?(Hash)
      end
    end

    class Array
      def extract_options!
        if last.is_a?(Hash) && last.extractable_options?
          pop
        else
          {}
        end
      end
    end
