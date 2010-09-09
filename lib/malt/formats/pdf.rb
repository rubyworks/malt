require 'malt/formats/abstract'

module Malt::Format

  #
  class PDF < Abstract

    register 'pdf'

    #
    def pdf
      text
    end

    #
    def to_pdf
      self
    end

    private

      #
      def render_engine
      end

  end

end

