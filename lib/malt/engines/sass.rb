require 'malt/engines/abstract'

module Malt::Engines

  # Sass Malt Engine
  #
  class Sass < Abstract

    #
    def intermediate(text, file=nil)
      ::Sass::Engine.new(text, :filename=>file)
    end

    #
    def render_css(text, file, *)
      engine = intermediate(text, file)
      engine.render
    end

    ;;;; private ;;;;

    # Load Sass library if not already loaded.
    def initialize_engine
      return if defined? ::Sass::Engine
      require_library 'sass'
    end

  end

end

