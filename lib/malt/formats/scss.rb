require 'malt/formats/abstract'
require 'malt/formats/css'
require 'malt/engines/sass'

module Malt::Format

  # SCSS Format
  #
  # This uses the same engine as Sass.
  class SCSS < Abstract

    register 'scss'

    #
    def scss(*)
      text
    end

    #
    def to_scss(*)
      self
    end

    #
    def css(*data, &yld)
      render_engine.render(:format=>:css, :text=>text, :file=>file, :data=>data, :type=>type)
    end

    #
    def to_css(*data, &yld)
      result = css(*data, &yld)
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
        @render_engine ||= Malt::Engine::Sass.new(options)
      end

      # Sass default output type is CSS.
      def default
        :css
      end

  end

end

