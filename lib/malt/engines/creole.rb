require 'malt/engines/abstract'

module Malt::Engine

  # Creole is a MediaWiki format for Ruby.
  #
  # @see http://github.com/larsch/creole

  class Creole < Abstract

    default :wiki, :creole

    # Convert WikiMedia format to HTML.
    # 
    def render(params={}, &content)
      into = parameters(params, :to)

      case into
      when :html, nil
        prepare_engine(params, &content).to_html
      else
        super(params)
      end
    end

    #
    #def prepare_engine(params={}, &content)
    #  create_engine(params)
    #end

    #
    def create_engine(params={})
      text = parameters(params, :text)
      opts = engine_options(params)

      cached(opts, text) do
        ::Creole::Parser.new(text, opts)
      end
    end

  private

    # Load `creole` library if not already loaded.
    def require_engine
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

