require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/radius'

module Malt::Formats

  # Radius Template
  #
  #   http://github.com/jlong/radius/
  #
  class Radius < Abstract

    register('radius')

    #
    def compile(db, &yld)
      result = render_engine.render(text, file, db, &yld)
      opts   = options.merge(:text=>result, :file=>refile(:html))
      HTML.new(opts)
    end

    #
    #def to_html(db, &yld)
    #  convert(:html, db, &yld)
    #end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engines::Radius.new(options)
      end

  end

end

