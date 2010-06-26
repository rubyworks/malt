require 'malt/formats/abstract'
require 'malt/engines/redcloth'

module Malt::Formats
 
  #
  class Textile < Abstract

    register('textile', 'tt')

    #
    def html(*)
      convert(:html)
    end

    #
    def render_to(to, *)
      case to
      when :textile, :tt
        self
      when :html
        malt_engine.render_html(text, file)
      else
        raise "can't render textile to #{to} type" #?
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Redcloth.new(options)
    end

  end

end

