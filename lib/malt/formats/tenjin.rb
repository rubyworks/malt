require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/tenjin'

module Malt::Formats

  # Tenjin
  #
  #   http://www.kuwata-lab.com/tenjin/
  #
  # TODO: fix tenjin
  class Tenjin < Abstract

    register 'tenjin', 'rbhtml'

    # Erb templates can be "precompiled" into Ruby templates.
    def to_rb
      @to_rb ||= (
        source = malt_engine.compile(text, file)
        Ruby.new(:text=>source, :file=>refile(:rb))
      )
    end

    alias_method(:to_ruby, :to_rb)

    #
    def to_html(db, &yld)
      # unless precompilation is turned off, convert to ruby
      return to_ruby.to_html(db, &yld) unless options[:recompile]
      convert(:html, db, &yld)
    end

    #
    #def render_to(to, db, &yld)
    #  #if options[:recompile]
    #    malt_engine.render(text, file, db, &yld)
    #  #else
    #  #  to_ruby.render(db, &yld)
    #  #end
    #end

    ;;;; private ;;;;

    #
    def render_engine
      @render_engine ||= Malt::Engines::Tenjin.new(options)
    end

  end

end

