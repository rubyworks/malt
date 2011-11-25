require 'malt/engines/abstract'

module Malt::Engine

  # Redcloth handles textile markup.
  #
  # @see http://redcloth.org/

  class RedCloth < Abstract

    default :tt, :textile

    # Convert textile text to html.
    # 
    # params:
    #
    #   :format => Symbol of the format to render [:html]
    #
    def render(params={})
      into, text = parameters(params, :to, :text)

      case into
      when :html, nil
        prepare_engine(params).to_html
      else
        super(params)
      end
    end

    #
    def create_engine(params={})
      text = parameters(params, :text)

      cached(text) do
        ::RedCloth.new(text)
      end
    end

  private

    # Load redcloth library if not already loaded.
    def require_engine
      return if defined? ::RedCloth
      require_library 'redcloth'
    end

  end

end

