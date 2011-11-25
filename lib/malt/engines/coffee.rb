require 'malt/engines/abstract'

module Malt::Engine

  # Coffee Malt Engine
  #
  class Coffee < Abstract

    default :coffee

    # Render coffee script to JavaScript.
    def render(params={}, &content)
      into, text, file = parameters(params, :to, :text, :file)

      case into
      when :javascript, :js, nil
        ::CoffeeScript.compile(text, engine_options(params))
      else
        super(params, &content)
      end
    end

    # TODO: make a psuedo intermediate ?
    # def prepare_engine(params)
    #   
    # end

  private

    # Load CoffeeScript library if not already loaded.
    def require_engine
      return if defined? ::CoffeeScript
      require_library 'coffee_script'
    end

    #
    def engine_options(params)
      options = {}
      options[:bare] = params[:bare] || params[:no_wrap] || false
      options
    end

  end

end

