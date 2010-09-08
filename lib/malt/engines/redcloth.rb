require 'malt/engines/abstract'

module Malt::Engines

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
      case params[:format]
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

