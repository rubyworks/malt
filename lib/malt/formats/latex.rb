require 'malt/formats/abstract'

module Malt::Formats

  #
  class Latex < Abstract

    register('latex')

    #
    def latex
      text
    end

    #
    def to_latex
      self
    end

    # TODO
    def pdf
      raise "not implemented yet"
    end

    # TODO
    def to_pdf
      opts = options.merge(:text=>pdf, :file=>refile(:pdf))
      PDF.new(opts)
    end

    private

      #
      def render_engine
      end

      # Latext default output type is PDF.
      def default
        :pdf
      end

  end

end

