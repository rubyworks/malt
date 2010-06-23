require 'malt/engines/abstract'
require 'malt/formats/rdoc'
require 'malt/formats/html'

module Malt::Engines

  # Discount Markdown implementation.
  #
  #   http://github.com/rtomayko/rdiscount
  #
  # The +:smart+ and +:filter_html+ options can be set true
  # to enable those flags on the underlying RDiscount object.
  class RDiscount < Abstract

    # Convert Markdown text to intermediate engine object.
    def intermediate(text, file=nil)
      ::RDiscount.new(text, *flags)
    end

    # Convert Markdown text to HTML text.
    def render_html(text, file=nil)
      intermediate(text, file).to_html
    end

    ;;;; private ;;;;

    # Load rdoc makup library if not already loaded.
    def initialize_engine
      return if defined? ::RDiscount
      require_library 'rdiscount'
    end

    #
    def flags
      [:smart, :filter_html].select{ |flag| options[flag] }
    end
  end

end

