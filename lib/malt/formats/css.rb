require 'malt/formats/abstract'

module Malt::Formats

  #
  class CSS < Abstract

    register('css')

    #
    def css(*)
      text
    end

    # CSS is CSS ;)
    def to_css(*)
      self
    end

    private

      #
      def render_engine
      end

      # CSS default output type is itself.
      def default
        :css
      end

  end

end

