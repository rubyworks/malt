require 'malt/engines/abstract'

module Malt::Engine

  # Creole is a MediaWiki format for Ruby.
  #
  # @see http://github.com/larsch/creole

  class Creole < Abstract

    default :wiki, :creole

    # Convert WikiMedia format to HTML.
    # 
    def render(params={}, &yld)
      case params[:to]
      when :html, nil
        intermediate(params).to_html
      else
        super(params)
      end
    end

    #
    def intermediate(params={})
      ::Creole::Parser.new(params[:text], engine_optoins(params))
    end

    private

    # Load `creole` library if not already loaded.
    def initialize_engine
      return if defined? ::Creole
      require_library 'creole'
    end

    #
    ENGINE_OPTION_NAMES = [:allowed_schemes, :extensions, :no_escape]

    #
    def engine_option_names
      ENGINE_OPTION_NAMES
    end

  end

end

