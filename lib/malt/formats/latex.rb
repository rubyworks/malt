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
    def engine
    end

  end

end

