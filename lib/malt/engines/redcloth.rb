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
      into = parameters(params, :to)

      case into
      when :html, nil
        intermediate(params).to_html
      else
        super(params)
      end
    end

    #
    def intermediate(params={})
      text = parameters(params, :text)

      ::RedCloth.new(text)
    end

  private

    # Load redcloth library if not already loaded.
    def initialize_engine
      return if defined? ::RedCloth
      require_library 'redcloth'
    end

  end

end

