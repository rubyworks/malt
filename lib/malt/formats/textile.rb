require 'malt/formats/abstract'
require 'malt/engines/redcloth'

module Malt::Format
 
  #
  class Textile < Abstract

    register('textile', 'tt')

    #
    def textile(*)
      text
    end

    #
    alias_method :tt, :textile

    #
    def to_textile(*)
      self
    end

    alias_method :to_tt, :to_textile

    #
    def html(*)
      render_engine.render(:format=>:html, :text=>text, :file=>file)
    end

    #
    def to_html(*)
      opts = options.merge(:text=>html, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    #def render_to(to, *)
    #  case to
    #  when :textile, :tt
    #    self
    #  when :html
    #    malt_engine.render_html(text, file)
    #  else
    #    raise "can't render textile to #{to} type" #?
    #  end
    #end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engine::RedCloth.new(options)
      end

  end

end

