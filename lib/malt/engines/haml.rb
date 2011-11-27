require 'malt/engines/abstract'

module Malt::Engine

  # Haml
  #
  class Haml < Abstract

    default :haml

    #
    def render(params={}, &content)
      into, scope, locals = parameters(params, :to, :scope, :locals)

      scope, locals = make_ready(scope, locals, &content)

      case into
      when :html, nil
        prepare_engine(params, &content).render(scope, locals, &content)
      else
        super(params, &content)
      end
    end

    #
    def create_engine(params={})
      text, file = parameters(params, :text, :file)
      cached(text, file) do
        ::Haml::Engine.new(text, :filename=>file)
      end
    end

  private

    # Load Haml library if not already loaded.
    def require_engine
      return if defined? ::Haml::Engine
      require_library 'haml'
    end

  end

end

