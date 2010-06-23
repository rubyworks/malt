require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/haml'

module Malt::Formats

  #
  class Haml < Abstract

    register('haml')

    #
    #def ruby(db, &yld)
    #  @ruby ||= (
    #    source = engine.compile(text, file)
    #    Ruby.new(:text=>source, :file=>refile(:rb))
    #  )
    #end

    #def html(db, &yml)
    #  convert(:html, db, &yml)
    #end

    ;;;; private ;;;;

    #
    def render(to, db, &yld)
      case to
      when :html
        engine.render_html(text, file, db, &yld)
      when :txt  # THINK: Does this make sense?
        text
      else
        raise UnspportedConversion.new(type, to)
      end
    end

    #
    def engine
      @engine ||= Malt::Engines::Haml.new(options)
    end

  end

end

