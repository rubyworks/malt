require 'malt/engines/abstract'

module Malt::Engine

  # Sass Malt Engine
  #
  class Sass < Abstract

    default :sass, :scss

    #
    def render(params, &yld)
      text   = params[:text]
      file   = params[:file]
      format = params[:format]

      case format
      when :css, nil
        engine = intermediate(params)
        engine.render
      else
        super(params, &yld)
      end
    end

    #
    def intermediate(params)
      text = params[:text]
      file = params[:file]
      type = params[:type]
      ::Sass::Engine.new(text, :filename=>file, :syntax=>type)
    end

    private

    # Load Sass library if not already loaded.
    def initialize_engine
      return if defined? ::Sass::Engine
      require_library 'sass'
    end

    #def engine_options
    #  opts = {}
    #  opts
    #end

  end

end

