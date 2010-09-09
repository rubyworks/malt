require 'malt/engines/abstract'

module Malt::Engine

  # Discount Markdown implementation.
  #
  #   http://github.com/rtomayko/rdiscount
  #
  # The +:smart+ and +:filter_html+ options can be set true
  # to enable those flags on the underlying RDiscount object.
  class Kramdown < Abstract

    register :markdown, :md

    # Convert Markdown text to HTML text.
    def render(params)
      text   = params[:text]
      format = params[:format]
      case format
      when :html, nil
        intermediate(params).to_html
      when :latex
        intermediate(params).to_latex
      else
        super(params)
      end
    end

    # Convert Markdown text to intermediate object.
    def intermediate(params)
      text = params[:text]
      ::Kramdown::Document.new(text)
    end


    private

      # Load rdoc makup library if not already loaded.
      def initialize_engine
        return if defined? ::Kramdown
        require_library 'kramdown'
      end

  end

end


