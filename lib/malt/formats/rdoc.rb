require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/rdoc'

module Malt::Formats

  #
  class RDoc < Abstract

    register('rdoc')

    #
    #def render(*)
    #  to_html.to_s
    #end

    #
    def html
      render_engine.render(:format=>:html, :text=>text, :file=>file)
      #malt_engine.html(text, file)
    end

    #
    def rdoc
      text
    end

    # THINK: Does this make sense? if it does it is for all formats.
    #def txt
    #  text
    #end

    #
    def to_rdoc
      self
    end

    #
    def to_html
      opts = options.merge(:text=>html, :file=>refile(:html))
      HTML.new(opts)
    end

    #raise UnsupportedConversion.new(type, to)

    ;;;; private ;;;;

    #
    def render_engine
      @render_engine ||= Malt::Engines::RDoc.new(options)
    end

  end

end

