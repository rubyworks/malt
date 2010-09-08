require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/haml'

module Malt::Formats

  # Haml looks like a Markup format, but it turns out to be
  # a template format too.
  class Haml < Abstract

    register('haml')

    #
    def compile(db, &yld)
      result = render_engine.render(text, file, db, &yld)
      opts = options.merge(:text=>result, :file=>refile(:html))
      HTML.new(opts)
    end

    #
    #def ruby(db, &yld)
    #  @ruby ||= (
    #    source = engine.compile(text, file)
    #    Ruby.new(:text=>source, :file=>refile(:rb))
    #  )
    #end

    #def to_html(db, &yld)
    #  #convert(:html, db, &yld)
    #end

    #def to_haml
    #  self
    #end

    #
    #def render_to(to, db=nil, &yld)
    #  case to
    #  when :haml
    #    text
    #  when :html
    #    malt_engine.render_html(text, file, db, &yld)
    #  when :txt  # THINK: Does this make sense?
    #    text
    #  else
    #    raise UnspportedConversion.new(type, to)
    #  end
    #end

    ;;;; private ;;;;

    #
    def render_engine
      @render_engine ||= Malt::Engines::Haml.new(options)
    end

  end

end

