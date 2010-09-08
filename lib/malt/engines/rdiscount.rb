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

    default :markdown, :md

    # Convert Markdown text to HTML text.
    def render(params)
      case params[:format]
      when :html, nil
        intermediate(params).to_html
      else
        super(params)
      end
    end

    # Convert Markdown text to intermediate engine object.
    def intermediate(params)
      text = params[:text]
      ::RDiscount.new(text, *flags)
    end

    private

    # Load rdoc makup library if not already loaded.
    def initialize_engine
      return if defined? ::RDiscount
      require_library 'rdiscount'
    end

    #
    def flags(params={})
      [:smart, :filter_html].select{ |flag| params[flag] || settings[flag] }
    end

  end

end

