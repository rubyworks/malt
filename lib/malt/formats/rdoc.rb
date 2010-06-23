require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/rdoc'

module Malt::Formats

  #
  class RDoc < Abstract

    register('rdoc')

    #
    def html(*)
      convert(:html)
      #output = render(:html. text, file)
      #HTML.new(:text=>output, :file=>refile('.html'))
    end

    ;;;; private ;;;;

    #
    def render(to, *)
      case to
      when :rdoc
        text
      when :html
        engine.render_html(text, file)
      when :txt  # THINK: Does this make sense?
        text
      else
        raise UnsupportedConversion.new(type, to)
      end
    end

    #
    def engine
      @engine ||= Malt::Engines::RDoc.new(options)
    end

  end

end

