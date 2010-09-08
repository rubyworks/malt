require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Formats

  # RHTML is a variant of Erb files which are limited to conversion to HTML.
  class RHTML < Abstract

    register('rhtml')

    #
    def compile(db, &yld)
      if options[:recompile]
        result = render_engine.render(db, &yld)
      else
        result = precompile.compile(db, &yld)
      end

      HTML.new(:text=>result, :file=>refile(:html))
    end

    #
    def precompile
      to_rb
    end

    # RHTML templates can be "pre-compiled" into Ruby templates.
    def to_rb
      @to_rb ||= (
        source = render_engine.compile(text, file)
        Ruby.new(:text=>source, :file=>refile(:html), :type=>'.html')
      )
    end

    #
    alias_method(:to_ruby, :to_rb)

    #
    #def to_html(db, &yld)
    #  # unless pre-compilation is turned off, convert to ruby
    #  return to_ruby.to_html(db, &yld) unless options[:recompile]
    #  convert(:html, db, &yld)
    #end

    #
    #def render_to(to, db, &yld)
    #  #if options[:recompile]
    #    render_engine.render(text, file, db, &yld)
    #  #else
    #  #  to_ruby.render(db, &yld)
    #  #end
    #end

    ;;;; private ;;;;

    #
    def render_engine
      @render_engine ||= (
        case engine
        when :erubis
          Malt::Engines::Erubis.new(options)
        else
          Malt::Engines::Erb.new(options)
        end
      )
    end

  end

end

