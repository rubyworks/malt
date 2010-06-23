require 'malt/formats/abstract'

module Malt::Formats

  #
  class HTML < Abstract

    register('html')

    # HTML is HTML ;)
    def html
      self
    end

    ;;;; private ;;;;

    #
    def engine
    end

  end

end

