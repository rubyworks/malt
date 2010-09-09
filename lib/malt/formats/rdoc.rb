require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/rdoc'

module Malt::Formats

  #
  class RDoc < Abstract

    register('rdoc')

    #
    def rdoc
      text
    end

    #
    def to_rdoc
      self
    end

    #
    def html
      render_engine.render(:text=>text, :file=>file, :format=>:html)
    end

    #
    def to_html
      opts = options.merge(:text=>html, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engines::RDoc.new(options)
    end

  end

end

