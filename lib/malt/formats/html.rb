require 'malt/formats/abstract'

module Malt::Format

  #
  class HTML < Abstract

    register 'html'

    #
    def html(*)
      text
    end

    # HTML is HTML ;)
    def to_html(*)
      self
    end

    private

      #
      def render_engine
      end

  end

end

