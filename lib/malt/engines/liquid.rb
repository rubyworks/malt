require 'malt/engines/abstract'

module Malt::Engines

  # Liquid
  #
  #   http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    #
    def intermediate(text, file=nil)
      ::Liquid::Template.parse(text)
    end

    #
    def render_html(text, file, db, &yld)
      engine = intermediate(text, file)
      db = make_hash(db, &yld)
      engine.render(db)
    end

    ;;;; private ;;;;

    # Load Liquid library if not already loaded.
    def initialize_engine
      return if defined? ::Liquid::Template
      require_library 'liquid'
    end

  end

end

