require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/haml'

module Malt::Formats

  #
  class Haml < Abstract

    register('rtal')

    #
    def compile(db, &yld)
      result = render_engine.render(text, db, &yld)

      fname = file.chomp('.rtal')
      fname = fname + '.html' unless file.extname.downcase == '.html'

      opts = options.merge(:text=>result, :file=>fname)

      HTML.new(opts)
    end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engines::RTALS.new(options)
      end

  end

end

