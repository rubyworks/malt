require 'malt/formats/abstract'

module Malt
module Format

  # An AbstractTemplate is a subclass of Abstract. It is used as the base class
  # for general purpose template formats which can be used to render any other
  # type of format.
  class AbstractTemplate < Abstract

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
      opts = options.merge(:format=>type, :text=>text, :file=>file, :data=>data)
      render_engine.render(opts, &yld)
      #opts = options.merge(:format=>type, :text=>text, :file=>file, :data=>data, :engine=>engine)
      #Malt.render(opts, &yld)
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

  end

end
end
