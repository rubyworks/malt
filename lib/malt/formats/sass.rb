require 'malt/formats/abstract'
require 'malt/formats/css'
require 'malt/engines/sass'

module Malt::Formats

  # Sass Malt Format
  #
  class Sass < Abstract

    register('sass')

    #
    def compile(db, &yld)
      result = render_engine.render(text, db, &yld)
      opts = options.merge(:text=>result, file=>refile(:css))
      CSS.new(opts)
    end

    #
    #def to_css(db, &yml)
    #  convert(:css, db, &yml)
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

