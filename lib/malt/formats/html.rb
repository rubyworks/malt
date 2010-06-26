require 'malt/formats/abstract'

module Malt::Formats

  #
  class HTML < Abstract

    register('html')

    # HTML is HTML ;)
    def html(*)
      self
    end

    ;;;; private ;;;;

    #
    def malt_engine
    end

  end

end

