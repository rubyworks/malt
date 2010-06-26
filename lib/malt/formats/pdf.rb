require 'malt/formats/abstract'

module Malt::Formats

  #
  class PDF < Abstract

    register('pdf')

    #
    def pdf
      self
    end

    ;;;; private ;;;;

    #
    def malt_engine
    end

  end

end

