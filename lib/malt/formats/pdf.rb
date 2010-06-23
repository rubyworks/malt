require 'malt/formats/abstract'

module Malt::Formats

  #
  class PDF < Abstract

    register('pdf')

    #
    def to_pdf
      text
    end

    ;;;; private ;;;;

    #
    def engine
    end

  end

end

