require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/latex'
require 'malt/engines/rdiscount'
require 'malt/engines/bluecloth'

module Malt::Format
 
  # If using the Kramdown engine, then Latex is also a supported output format.
  class Markdown < Abstract

    register('markdown', 'md')

    #
    def html(*)
      render_engine.render(:text=>text, :file=>file, :format=>:html)
    end

    #
    def latex(*)
      render_engine.render(:text=>text, :file=>file, :format=>:latex)
    end

    #
    def markdown(*)
      text
    end

    #
    alias_method :md, :markdown

    # Convert to HTML.
    def to_html(*)
      opts = options.merge(:text=>html, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    # Latex is only supported by the Kramdown engine.
    def to_latex(*)
      opts = options.merge(:text=>html, :file=>refile(:latex), :type=>:latex)
      Latex.new(opts)
    end

    #
    def to_markdown(*)
      self
    end

    #
    alias_method :to_md, :to_markdown

    #
    #def render_to(to, *)
    #  case to
    #  when :markdown, :md
    #    text
    #  when :html
    #    malt_engine.render_html(text, file)
    #  when :txt  # THINK: Does this make sense?
    #    text
    #  end
    #end

    private

      #
      def render_engine
        @render_engine ||= (
          case engine
          when :bluecloth
            Malt::Engine::BlueCloth.new(options)
          when :kramdown
            Malt::Engine::Kramdown.new(options)
          else
            Malt::Engine::RDiscount.new(options)
          end
        )
      end

  end

end

