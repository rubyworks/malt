require 'malt/formats/abstract'
require 'malt/engines/liquid'

module Malt::Formats
 
  # Liquid templates
  #
  #   http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    register 'liquid'

    #
    def to(type, data=nil, &yld)
      type = type.to_sym
      new_class   = Malt.registry[type]
      new_text    = render(data, &yld)
      new_file    = refile(type)
      new_options = options.merge(:text=>new_text, :file=>new_file, :type=>type)
      new_class.new(new_options)
    end

    #
    def render(*type_and_data, &yld)
      type, data = parse_type_and_data(type_and_data)
      render_engine.render(:text=>text, :file=>file, :data=>data, &yld)
    end

    # Liquid templates can be any type.
    def method_missing(sym, *args, &yld)
      if Malt.registry.key?(sym)
        return render(sym, *args, &yld)
      elsif md = /^to_/.match(sym.to_s)
        type = md.post_match.to_sym
        if Malt.registry.key?(type)
          return to(type, *args, &yld)
        end
      end
      super(sym, *args, &yld)
    end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engines::Liquid.new(options)
      end

  end

end

