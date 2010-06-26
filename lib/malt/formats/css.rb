require 'malt/formats/abstract'

module Malt::Formats

  #
  class CSS < Abstract

    register('css')

    # CSS is CSS ;)
    def css(*)
      self
    end

    ;;;; private ;;;;

    #
    def malt_engine
    end

    # CSS default output type is itself.
    def default
      :css
    end

  end

end

