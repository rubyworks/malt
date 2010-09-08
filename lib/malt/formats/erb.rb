require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Formats

  # Erb files are really any kind of file,
  # but they of course have <% %> slots.
  class Erb < Abstract

    register('erb')

    # Erb templates can be "pre-compiled" into Ruby templates.
    def to_rb(*)
      @to_rb ||= (
        source = render_engine.compile(:text=>text, :file=>file)
        Ruby.new(:text=>source, :file=>refile(:rb))
      )
    end

    #
    alias_method(:to_ruby, :to_rb)

    #
    alias_method :precompile, :to_rb

    #
    def to(type, db=nil, &yld)
      new_class   = Malt.registry[type.to_sym]
      new_text    = render(db, &yld)
      new_file    = refile(type)
      new_options = options.merge(:text=>new_text, :file=>new_file)
      new_class.new(new_options)
    end

    #
    def render(params={}, &yld)
      if options[:recompile]
        render_engine.render(params, &yld)
      else
        precompile.render(params, &yld)
      end
    end

    # ERB templates can be any type.
    def method_missing(sym, *args, &yld)
      if Malt.registry.key?(sym)
        return to(sym, *args, &yld).to_s
      elsif md = /^to_/.match(sym.to_s)
        type = md.post_match.to_sym
        if Malt.registry.key?(type)
          return to(type, *args, &yld)
        end
      end
      super(sym, *args, &yld)
    end

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
