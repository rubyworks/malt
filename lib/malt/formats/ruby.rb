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
  class Ruby < Abstract

    register 'rb'

    #
    def rb ; text ; end
    alias_method :ruby, :rb

    #
    def to_rb ; self ; end
    alias_method :to_ruby, :to_rb

    #
    def to(type, data=nil, &yld)
      new_class   = Malt.registry[type.to_sym]
      new_text    = render(data, &yld)
      new_file    = refile(type)
      new_options = options.merge(:text=>new_text, :file=>new_file)
      new_class.new(new_options)
    end

    # Ruby templates can be any type.
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
    #def render_to(to, db, &yld)
    #  malt_engine.render(text, file, db, &yld)
    #end

    def render(*type_and_data, &yld)
      type, data = parse_type_and_data(type_and_data)
      render_engine.render(:text=>text, :file=>file, :data=>data, &yld)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engine::Ruby.new(options)
    end

  end

end
