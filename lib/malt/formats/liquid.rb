require 'malt/formats/abstract'
require 'malt/engines/liquid'

module Malt::Formats
 
  # Liquid templates
  #
  #   http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    register('liquid')

    #
    def to(type, db=nil, &yld)
      new_class   = Malt.registry[type.to_sym]
      new_text    = render(db, &yld)
      new_file    = refile(type)
      new_options = options.merge(:text=>new_text, :file=>new_file)
      new_class.new(new_options)
    end

    #
    def render(data, &yld)
      render_engine.render(:text=>text, :file=>file, :data=>data, &yld)
      #opts = options.merge(:text=>result, :file=>refile)
      #Malt.text(result, opts)
    end

    #
    #def render(db=nil, &yld)
    #  render_engine.render(default, text, file, db, &yld)
    #end

    # Liquid templates can be any type.
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

    private

      #
      def render_engine
        @render_engine ||= Malt::Engines::Liquid.new(options)
      end

  end

end

