require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/rdoc'

module Malt::Formats

  #
  class RDoc < Abstract

    register('rdoc')

    #
    def html(*)
      convert(:html)
    end

    #
    def render_to(to, *)
      case to
      when :rdoc
        text
      when :html
        malt_engine.render_html(text, file)
      when :txt  # THINK: Does this make sense?
        text
      else
        raise UnsupportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::RDoc.new(options)
    end

  end

end

