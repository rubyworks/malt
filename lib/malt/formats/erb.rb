require 'malt/formats/abstract_template'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Format

  #
  class Erb < AbstractTemplate

    register 'erb'

    # TODO: Lookup engine from engine registry.
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

    # Technically #method_missing will pick this up, but since it is likely
    # to be the most commonly used, adding the method directly will provide
    # a small speed boost.
    def html(data=nil, &yld)
      render(:html, data, &yld)
    end

    # Technically #method_missing will pick this up, but since it is likely
    # to be the most commonly used, adding the method directly will provide
    # a small speed boost.
    def to_html(data=nil, &yld)
      new_text    = render(:html, data, &yld)
      new_file    = refile(:html)
      new_options = options.merge(:text=>new_text, :file=>new_file, :type=>:html)
      HTML.new(new_options)
    end

#    #
#    def to(type, data=nil, &yld)
#      new_class   = Malt.registry[type.to_sym]
#      new_text    = render(type, data, &yld)
#      new_file    = refile(type)
#      new_options = options.merge(:text=>new_text, :file=>new_file, :type=>type)
#      new_class.new(new_options)
#    end

#    #
#    def render(*type_and_data, &yld)
#      type, data = parse_type_and_data(type_and_data)
#      opts = options.merge(:format=>type, :text=>text, :file=>file, :data=>data)
#      #opts = options.merge(:format=>type, :text=>text, :file=>file, :data=>data, :engine=>engine)
#      #Malt.render(opts, &yld)
#      #if options[:recompile]
#        render_engine.render(opts, &yld)
#      #else
#      # precompile.render(type, data, &yld)
#      #end
#    end


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
          Malt::Engine::Erubis.new(options)
        else
          Malt::Engine::Erb.new(options)
        end
      )
    end

  end

end
