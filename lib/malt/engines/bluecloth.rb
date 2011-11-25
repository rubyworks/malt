require 'malt/engines/abstract'

module Malt::Engine

  #
  class BlueCloth < Abstract

    register :markdown, :md

    # Convert Markdown text to HTML text.
    def render(params={})
      into = params[:to]

      text = parameters(params, :text)

      case into
      when :html, nil
        prepare_engine(params).to_html
      else
        super(params)
      end
    end

    # Prepare engine for rendering.
    #def prepare_engine(params={})
    #  create_engine(params)
    #end

    # Instantiate engine class and cache if applicable.
    def create_engine(params={})
      text = parameters(params, :text)

      cached(text) do
        ::BlueCloth.new(text)
      end
    end

  private

    # Load bluecloth library if not already loaded.
    def require_engine
      return if defined? ::BlueCloth
      require_library 'bluecloth'
    end

  end

end

