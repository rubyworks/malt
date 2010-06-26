require 'malt/formats/abstract'
require 'malt/formats/css'
require 'malt/engines/sass'

module Malt::Formats

  # Sass Malt Format
  #
  class Sass < Abstract

    register('sass')

    #
    def css(db, &yml)
      convert(:css, db, &yml)
    end

    #
    def render_to(to, db, &yld)
      case to
      when :css
        malt_engine.render_css(text, file, db, &yld)
      else
        raise UnspportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Sass.new(options)
    end

    # Sass default output type is CSS.
    def default
      :css
    end

  end

end

