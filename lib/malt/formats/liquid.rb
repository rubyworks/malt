require 'malt/formats/abstract'
require 'malt/engines/redcloth'

module Malt::Formats
 
  # Liquid templates
  #
  #   http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    register('liquid')

    #
    def html(db, &yld)
      convert(:html, db, &yld)
    end

    #
    def render_to(to, db, &yld)
      case to
      when :liquid
        text
      when :html
        malt_engine.render_html(text, file, db, &yld)
      else
        raise UnspportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Liquid.new(options)
    end

  end

end

