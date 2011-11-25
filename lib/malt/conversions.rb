module Malt

  module Conversions

    module Binding
      extend self

      #
      def to_binding(binding)
        binding
      end

      #
      def to_hash(binding)
        Hash.new{ |h,k| h[k] = binding.eval(k) }
      end

      #
      def to_object(binding)
        obj = binding.eval("self")

        vars  = binding.eval("local_variables")
        vals  = binding.eval("[#{vars.join(',')}]")
        data  = Hash[*vars.zip(vals).flatten]

        adhoc = (class << obj; self; end)
        data.each do |name,value|
          adhoc.__send__(:define_method, name){ value }
        end

        obj
      end

    end

    module Object

    end

  end

end
