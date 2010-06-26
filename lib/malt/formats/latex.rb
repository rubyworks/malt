require 'malt/formats/abstract'

module Malt::Formats

  #
  class Latex < Abstract

    register('latex')

    #
    def latex(*)
      self
    end

    # TODO
    def pdf(*)
      convert(:pdf)
    end

    ;;;; private ;;;;

    #
    def malt_engine
    end

    # Latext default output type is PDF.
    def default
      :pdf
    end

  end

end

