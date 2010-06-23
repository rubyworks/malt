require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'

module Malt::Formats

  # Erb files are really any kind of file,
  # but they of course have <% %> slots.
  class Erb < Abstract

    register('erb')

    # Erb templates can be "precompiled" into Ruby templates.
    def ruby
      @ruby ||= (
        source = malt_engine.compile(text, file)
        Ruby.new(:text=>source, :file=>refile(:rb))
      )
    end

    #
    def html(db, &yld)
      # unless precompilation is turned off, convert to ruby
      return ruby.html(db, &yld) unless options[:recompile]

      convert(:html, db, &yld)

      #output = render(:html, db, &yld)
      #
      #if subclass = Malt.registry[subtype]
      #  subclass.new(:text=>output, :file=>file.chomp('.erb')).html(db, &yld)
      #else
      #  HTML.new(:text=>output, :file=>refile(:html), :fallback=>true)
      #end
    end

    #
    def render(to, db, &yld)
      #if options[:recompile]
        malt_engine.render(text, file, db, &yld)
      #else
      #  to_ruby.render(db, &yld)
      #end
    end

    ;;;; private ;;;;

    #
    def malt_engine
      case options[:engine]
      when :erubis
        @malt_engine ||= Malt::Engines::Erubis.new(options)
      else
        @malt_engine ||= Malt::Engines::Erb.new(options)
      end
    end

  end

end

