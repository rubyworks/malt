require 'malt/engines/abstract'

module Malt::Engines

  # Discount Markdown implementation.
  #
  #   http://github.com/rtomayko/rdiscount
  #
  # The +:smart+ and +:filter_html+ options can be set true
  # to enable those flags on the underlying RDiscount object.
  class Kramdown < Abstract

    # Convert Markdown text to intermediate object.
    def intermediate(text, file=nil)
      ::Kramdown::Document.new(text)
    end

    # Convert Markdown text to HTML text.
    def render_html(text, file=nil)
      intermediate(text, file).to_html
    end

    # Convert Markdown text to Latex text.
    def render_latex(text, file=nil)
      intermediate(text, file).to_latex
    end

    ;;;; private ;;;;

    # Load rdoc makup library if not already loaded.
    def initialize_engine
      return if defined? ::Kramdown
      require_library 'kramdown'
    end

  end

end


