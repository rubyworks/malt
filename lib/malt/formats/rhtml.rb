require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Formats

  # RHTML is a variant of Erb files which are limited to conversion to HTML.
  class RHTML < Abstract

    register 'rhtml'

    # RHTML templates can be "pre-compiled" into Ruby templates.
    def rb(*)
      render_engine.compile(:text=>text, :file=>file)
    end

    # RHTML templates can be "pre-compiled" into Ruby templates.
    def to_rb(*)
      text = rb
      Ruby.new(:text=>text, :file=>refile(:rb), :type=>:rb)
    end

    #
    alias_method(:to_ruby, :to_rb)

    #
    alias_method(:precompile, :to_rb)

    #
    def html(data=nil, &yld)
      render_engine.render(:text=>text, :file=>file, :format=>:html)
    end

    #
    def to_html(data=nil, &yld)
      text = html(data, &yld)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    #def render(data, &yld)
    #  if options[:recompile]
    #    result = render_engine.render(db, &yld)
    #  else
    #    result = precompile.compile(db, &yld)
    #  end
    #
    #  HTML.new(:text=>result, :file=>refile(:html))
    #end

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

    private

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

