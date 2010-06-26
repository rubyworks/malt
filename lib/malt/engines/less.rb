require 'malt/engines/abstract'

module Malt::Engines

  # LESS
  #
  #   http://lesscss.org/
  #
  # LESS is an extension of CSS. You can write LESS code just like you would write CSS,
  # except you need to compile it to CSS. That's what this is class is for.
  class Less < Abstract

    #
    def intermediate(text, file=nil)
      ::Less::Engine.new(text)
    end

    #
    #def compile(text, file)
    #  intermediate # ??
    #end

    #
    def render_css(text, file, db, &block)
      intermediate(text, file).to_css
    end

    ;;;; private ;;;;

    # Load Less library if not already loaded.
    def initialize_engine
      return if defined? ::Less::Engine
      require_library 'less'
    end

  end

end

