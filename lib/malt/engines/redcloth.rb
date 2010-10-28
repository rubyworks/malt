require 'malt/engines/abstract'

module Malt::Engine

  #
  class RedCloth < Abstract

    default :tt, :textile

    # Convert textile text to html.
    # 
    # params:
    #
    #   :format => Symbol of the format to render [:html]
    #
    def render(params={})
      case params[:to]
      when :html, nil
        intermediate(params).to_html
      else
        super(params)
      end
    end

    #
    def intermediate(params={})
      text = params[:text]
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

