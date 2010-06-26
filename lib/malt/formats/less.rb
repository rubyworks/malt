require 'malt/formats/abstract'
require 'malt/engines/less'

module Malt::Formats

  #
  class Less < Abstract

    register('less')

    #
    def css(*)
      convert(:css)
    end

    #
    def render_to(to, *)
      case to
      when :css
        malt_engine.render_css(text, file)
      else
        raise UnsupportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Less.new(options)
    end

    # LESS default output type is CSS.
    def default
      :css
    end

  end

end

