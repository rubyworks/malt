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

    ;;;; private ;;;;

    #
    def render(to, *)
      case to
      when :textile, :tt
        self
      when :html
        engine.render_html(text, file)
      else
        raise "can't render textile to #{to} type" #?
      end
    end

    #
    def engine
      @engine ||= Malt::Engines::Redcloth.new(options)
    end

  end

end

