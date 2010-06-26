require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/tenjin'

module Malt::Formats

  # Tenjin
  #
  #   http://www.kuwata-lab.com/tenjin/
  #
  class Tenjin < Abstract

    register('rbhtml')

    # Erb templates can be "precompiled" into Ruby templates.
    def rb
      @rb ||= (
        source = malt_engine.compile(text, file)
        Ruby.new(:text=>source, :file=>refile(:rb))
      )
    end
    alias_method(:ruby, :rb)

    #
    def html(db, &yld)
      # unless precompilation is turned off, convert to ruby
      return ruby.html(db, &yld) unless options[:recompile]
      convert(:html, db, &yld)
    end

    #
    def render_to(to, db, &yld)
      #if options[:recompile]
        malt_engine.render(text, file, db, &yld)
      #else
      #  to_ruby.render(db, &yld)
      #end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Tenjin.new(options)
    end

  end

end

