require 'malt/engines/abstract'

module Malt::Engines

  # Ruby as a template engine.
  #
  #   http://
  #
  class Ruby < Abstract

    # Ruby compiles to Ruby. How odd. ;)
    def compile(text, file)
      text
    end

    #
    def render(text, file, db, &yld)
      db = make_binding(db, &yld)
      eval(text, db, file)
    end

    ;;;; private ;;;;

    #
    def initialize_engine
    end

  end

end

