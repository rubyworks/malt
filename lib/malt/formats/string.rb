require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'

module Malt::Format

  # Yes, pure Ruby as a template format.
  #
  # The ruby code is run through eval and whatever is returned is given
  # as the rendering.
  #
  # The Ruby format is a *polyglot* format --it accepts all conversion
  # types and assumes the end-user knows it will be the result.
  #
  # The Ruby type is also used for "precompiling" other formats such
  # as ERB.
  #
  class String < AbstractTemplate

    register '.str'

    #
    def string(*) ; text ; end

    #
    def to_string(*) ; self ; end

    #
    def to(type, *data, &yld)
      new_class   = Malt::Format.registry[type.to_sym]  # TODO: Malt.machine.format?
      new_text    = render(*data, &yld)
      new_file    = refile(type)
      new_options = options.merge(:text=>new_text, :file=>new_file)
      new_class.new(new_options)
    end

    # Ruby templates can be any type.
    def method_missing(sym, *args, &yld)
      if Malt::Format.registry.key?(sym)
        return to(sym, *args, &yld).to_s
      elsif md = /^to_/.match(sym.to_s)
        type = md.post_match.to_sym
        if Malt::Format.registry.key?(type)  # TODO: Malt.machine.format?
          return to(type, *args, &yld)
        end
      end
      super(sym, *args, &yld)
    end

    #
    #def render_to(to, db, &yld)
    #  malt_engine.render(text, file, db, &yld)
    #end

    def render(*type_and_data, &yld)
      type, data = parse_type_from_data(*type_and_data)
      render_engine.render(:text=>text, :file=>file, :data=>data, &yld)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engine::String.new(options)
    end

  end

end
