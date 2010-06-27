require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/haml'

module Malt::Formats

  #
  class Haml < Abstract

    register('rtal')

    #
    def html(db, &yml)
      convert(:html, db, &yml)
    end

    #
    def render_to(to, db=nil, &yld)
      case to
      when :rtal
        text
      when :html
        malt_engine.render_html(text, file, db, &yld)
      when :txt  # THINK: Does this make sense?
        text
      else
        raise UnspportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::RTALS.new(options)
    end

  end

end

