require 'malt/engines/abstract'

module Malt::Engine

  #
  class BlueCloth < Abstract

    register :markdown, :md

    # Convert Markdown text to HTML text.
    def render(params)
      text   = params[:text]
      format = params[:format]
      case format
      when :html, nil
        intermediate(params).to_html
      else
        super(params)
      end
    end

    # Convert Markdown text to intermediate object.
    def intermediate(params)
      text = params[:text]
      ::BlueCloth.new(text)
    end

    private

    # Load bluecloth library if not already loaded.
    def initialize_engine
      return if defined? ::BlueCloth
      require_library 'bluecloth'
    end

  end

end

