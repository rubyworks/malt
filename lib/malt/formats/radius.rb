require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/radius'

module Malt::Formats

  # Radius Template
  #
  #   http://github.com/jlong/radius/
  #
  class Radius < Abstract

    register('haml')

    #
    def html(db, &yml)
      convert(:html, db, &yml)
    end

    #
    def render_to(to, db, &yld)
      case to
      when :radius
        text  # self ?
      when :html
        malt_engine.render_html(text, file, db, &yld)
      else
        raise UnspportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Radius.new(options)
    end

  end

end

