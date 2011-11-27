require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/latex'
require 'malt/engines/rdiscount'
require 'malt/engines/bluecloth'
require 'malt/engines/maruku'
require 'malt/engines/redcarpet'
require 'malt/engines/kramdown'

module Malt::Format
 
  # If using the Kramdown engine, then Latex is also a supported output format.
  class Markdown < Abstract

    register('markdown', 'md')

    #
    def markdown(*)
      text
    end

    alias_method :md, :markdown

    #
    def to_markdown(*)
      self
    end

    alias_method :to_md, :to_markdown

    #
    def html(*data, &context)
      #engine.render(:text=>text, :file=>file, :format=>:html)
      render_into(:html, *data, &context)
    end

    # Convert to HTML.
    def to_html(*)
      opts = options.merge(:text=>html, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    def latex(*data, &content)
      render_into(:latex, *data, &content)
      #render_engine.render(:text=>text, :file=>file, :format=>:latex)
    end

    # Latex is only supported by the Kramdown engine.
    def to_latex(*)
      opts = options.merge(:text=>html, :file=>refile(:latex), :type=>:latex)
      Latex.new(opts)
    end

=begin
   private

    # Select rendering engine.
    def render_engine
      @render_engine ||= (
        case engine
        when :bluecloth
          Malt::Engine::BlueCloth.new(options)
        when :kramdown
          Malt::Engine::Kramdown.new(options)
        when :rdiscount
          Malt::Engine::RDiscount.new(options)
        when :redcarpet
          Malt::Engine::Redcarpet.new(options)
        when :maruku
          Malt::Engine::Maruku.new(options)
        else
          #Malt::Engine::Redcarpet.new(options)  # TODO: new default ?
          Malt::Engine::RDiscount.new(options)
        end
      )
    end
=end

  end

end
