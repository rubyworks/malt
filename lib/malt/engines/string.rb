require 'malt/engines/abstract'

module Malt::Engine

  # Ruby strings as template engine.
  #
  # @see http://ruby-lang.org
  #
  class String < Abstract

    default :str

    #
    def render(params={}, &yld)
      text, file, data = parameters(params, :text, :file, :data)

      # @note If this supported yield, it would be all we need:
      #   binding = make_binding(data, &yld)
      #   eval("%{#{text}}", binding, file)

      scope, data = make_scope_and_data(data)
      vars, vals  = data.keys, data.values
      ruby = <<-END
        def ___erb(#{vars.join(',')})
          %{#{text}}
        end
        method(:___erb)
      END
      eval(ruby, scope.to_binding, file).call(*vals, &yld)
    end

    # Ruby compiles to Ruby. How odd. ;)
    def compile(text, file)
      text
    end

  private

    #
    def initialize_engine
    end

  end

end

