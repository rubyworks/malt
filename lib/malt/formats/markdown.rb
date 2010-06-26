require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/latex'
require 'malt/engines/rdiscount'
require 'malt/engines/bluecloth'

module Malt::Formats
 
  # If using the Kramdown engine, then Latex is
  # also a supported output format.
  class Markdown < Abstract

    register('markdown', 'md')

    #
    def html(*)
      convert(:html)
    end

    # Only supported by the Kramdown engine.
    def latex(*)
      convert(:latex)
    end

    #
    def render_to(to, *)
      case to
      when :markdown, :md
        text
      when :html
        malt_engine.render_html(text, file)
      when :txt  # THINK: Does this make sense?
        text
      end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= (
        case engine
        when :bluecloth
          Malt::Engines::BlueCloth.new(options)
        when :kramdown
          Malt::Engines::Kramdown.new(options)
        else
          Malt::Engines::RDiscount.new(options)
        end
      )
    end

  end

end

