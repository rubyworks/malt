require 'malt/engines/abstract'

module Malt::Engine

  # Coffee Malt Engine
  #
  class Coffee < Abstract

    default :coffee

    # Render coffee script to JavaScript.
    def render(params, &yld)
      text = params[:text]
      file = params[:file]
      into = params[:to]

      case into
      when :javascript, :js, nil
        ::CoffeeScript.compile(text, engine_options(params))
      else
        super(params, &yld)
      end
    end

  private

    # Load CoffeeScript library if not already loaded.
    def initialize_engine
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

