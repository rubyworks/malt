require 'malt/engines/abstract'

module Malt::Engine

  # Ruby strings as template engine.
  #
  # @see http://ruby-lang.org
  #
  class String < Abstract

    default :str

    #
    def render(params={}, &content)
      text, file, scope, locals = parameters(params, :text, :file, :scope, :locals)

      bind = make_binding(scope, locals, &content)
      eval("%{#{text}}", bind, file || '(eval)')
    end

    # Ruby compiles to Ruby. How odd. ;)
    def compile(params)
      text = parameters(params, :text)
      "%{#{text}}"
    end

  private

    #
    def require_engine
    end

  end

end

