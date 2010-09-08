require 'malt/formats/abstract'
require 'malt/engines/less'

module Malt::Formats

  #
  class Less < Abstract

    register('less')

    #
    def css
      render_engine.render(text) #,file)
    end

    #
    def to_css
      opts = options.merge(:text=>css, file=>refile(:css))
      CSS.new(opts)
    end

    #
    def less
      text
    end

    #
    def to_less
      self
    end

    #
    #def render_to(to, *)
    #  case to
    #  when :css
    #    malt_engine.render_css(text, file)
    #  else
    #    raise UnsupportedConversion.new(type, to)
    #  end
    #end

    ;;;; private ;;;;

    #
    def render_engine
      @render_engine ||= Malt::Engines::Less.new(options)
    end

    # LESS default output type is CSS.
    def default
      :css
    end

  end

end

