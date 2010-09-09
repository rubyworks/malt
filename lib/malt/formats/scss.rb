require 'malt/formats/abstract'
require 'malt/formats/css'
require 'malt/engines/sass'

module Malt::Formats

  # SCSS Format
  #
  # This uses the same engine as Sass.
  class SCSS < Abstract

    register 'scss'

    #
    def css(data=nil, &yld)
      render_engine.render(:format=>:css, :text=>text, :file=>file, :type=>type)
    end

    #
    def to_css(data=nil, &yld)
      result = css(data, &yld)
      CSS.new(:text=>result, :file=>refile(:css), :type=>:css)
    end

    #
    #def compile(db, &yld)
    #  result = render_engine.render(text, db, &yld)
    #  opts = options.merge(:text=>result, file=>refile(:css))
    #  CSS.new(opts)
    #end

    #
    #def render_to(to, db, &yld)
    #  case to
    #  when :css
    #    malt_engine.render_css(text, file, db, &yld)
    #  else
    #    raise UnspportedConversion.new(type, to)
    #  end
    #end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engines::Sass.new(options)
      end

      # Sass default output type is CSS.
      def default
        :css
      end

  end

end

