require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Formats

  # Erb files are really any kind of file,
  # but they of course have <% %> slots.
  class Erb < Abstract

    register 'erb'

    #
    def rb(*)
      render_engine.compile(:text=>text, :file=>file)
    end

    # Erb templates can be "pre-compiled" into Ruby templates.
    def to_rb(*)
      text = rb
      Ruby.new(:text=>text, :file=>refile(:rb))
    end

    #
    alias_method(:to_ruby, :to_rb)

    #
    alias_method :precompile, :to_rb

    #
    def to(type, data=nil, &yld)
      new_class   = Malt.registry[type.to_sym]
      new_text    = render(type, data, &yld)
      new_file    = refile(type)
      new_options = options.merge(:text=>new_text, :file=>new_file, :type=>type)
      new_class.new(new_options)
    end

    #
    def render(*type_and_data, &yld)
      type, data = parse_type_and_data(type_and_data)
      if options[:recompile]
        render_engine.render(:format=>type,:text=>text,:file=>file,:data=>data, &yld)
      else
        precompile.render(type, data, &yld)
      end
    end

    # ERB templates can be any type.
    def method_missing(sym, *args, &yld)
      if Malt.registry.key?(sym)
        return render(sym, *args, &yld).to_s
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
