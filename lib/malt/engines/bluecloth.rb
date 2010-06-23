require 'malt/engines/abstract'

module Malt::Engines

  #
  class BlueCloth < Abstract

    # Convert Markdown text to intermediate object.
    def intermediate(text, file=nil)
      ::BlueCloth.new(text)
    end

    # Convert Markdown text to HTML text.
    def render_html(text, file=nil)
      intermediate(text, file).to_html
    end

    ;;;; private ;;;;

    # Load bluecloth library if not already loaded.
    def initialize_engine
      return if defined? ::BlueCloth
      require_library 'bluecloth'
    end

  end

end

