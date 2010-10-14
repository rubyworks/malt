require 'malt/formats/abstract'
require 'malt/formats/pdf'

module Malt::Format

  #
  class Latex < Abstract

    register 'latex'

    #
    def latex(*)
      text
    end

    #
    def to_latex(*)
      self
    end

    # TODO
    def pdf(*)
      raise "not implemented yet"
    end

    # TODO
    def to_pdf(*)
      text = pdf
      opts = options.merge(:text=>text, :file=>refile(:pdf), :type=>:pdf)
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

