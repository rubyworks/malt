require 'malt/formats/abstract'
require 'malt/engines/redcloth'

module Malt::Format
 
  #
  class Textile < Abstract

    file_extension 'textile', 'tt'

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
    def html(*data, &content)
      render_into(:html, *data, &content)
    end

    #
    def to_html(*)
      opts = options.merge(:text=>html, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #private
    #
    ##
    #def render_engine
    #  @render_engine ||= Malt::Engine::RedCloth.new(options)
    #end

  end

end

