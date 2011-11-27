require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/rdoc'

module Malt::Format

  #
  class RDoc < Abstract

    file_extension 'rdoc'

    #
    def rdoc(*)
      text
    end

    #
    def to_rdoc(*)
      self
    end

    #
    def html(*data, &content)
      render_into(:html, *data, &content)
      #render_engine.render(:format=>:html, :text=>text, :file=>file)
    end

    #
    def to_html(*)
      opts = options.merge(:type=>:html, :text=>html, :file=>refile(:html))
      HTML.new(opts)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engine::RDoc.new(options)
    end

  end

end

