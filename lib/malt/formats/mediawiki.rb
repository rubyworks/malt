require 'malt/formats/abstract'
require 'malt/formats/html'
#require 'malt/formats/latex'
require 'malt/engines/creole'
require 'malt/engines/wikicloth'

module Malt::Format
 
  #
  class MediaWiki < Abstract

    register('mediawiki', 'mw')

    #
    def mediawiki(*)
      text
    end

    #
    def to_mediawiki(*)
      self
    end

    alias_method :mw, :mediawiki
    alias_method :to_mw, :to_mediawiki

    #
    def html(*)
      render_engine.render(:text=>text, :file=>file, :format=>:html)
    end

    # Convert to HTML.
    def to_html(*)
      opts = options.merge(:text=>html, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    #def latex(*)
    #  render_engine.render(:text=>text, :file=>file, :format=>:latex)
    #end

    # Latex is only supported by the Kramdown engine.
    #def to_latex(*)
    #  opts = options.merge(:text=>html, :file=>refile(:latex), :type=>:latex)
    #  Latex.new(opts)
    #end

   private

    # Select rendering engine.
    def render_engine
      @render_engine ||= (
        case engine
        when :creole
          Malt::Engine::Creole.new(options)
        when :wikicloth
          Malt::Engine::WikiCloth.new(options)
        else
          Malt::Engine::WikiCloth.new(options)
        end
      )
    end

  end

end
