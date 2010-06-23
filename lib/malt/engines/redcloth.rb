require 'malt/engines/abstract'

module Malt::Engines

  #
  class RedCloth < Abstract

    #
    def intermediate(text, file=nil)
      RedCloth.new(text)
    end

    # Convert textile text to html.
    def render_html(text, file=nil)
      intermediate(text, file).to_html
    end

    ;;;; private ;;;;

    # Load redcloth library if not already loaded.
    def initialize_engine
      return if defined? ::RedCloth
      require_library 'redcloth'
    end

  end

end

