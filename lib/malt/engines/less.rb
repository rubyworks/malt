require 'malt/engines/abstract'

module Malt::Engine

  # LESS is an extension of CSS. You can write LESS code just like you
  # would write CSS, except you need to compile it to CSS.
  #
  # @see http://lesscss.org/
  #
  class Less < Abstract

    default :less

    #
    def render(params={})
      into, text, compress = parameters(params, :to, :text, :compress)

      case into
      when :css, nil
        prepare_engine(params).to_css(:compress=>compress)
      else
        super(params)
      end
    end

    #
    def create_engine(params={})
      text, file = parameters(params, :text, :file)
      cached(text, file) do
        ::Less::Parser.new(:filename=>file).parse(text)
      end
    end

    #
    #def compile(text, file)
    #  intermediate # ??
    #end

  private

    # Load Less library if not already loaded.
    def require_engine
      return if defined? ::Less::Parser
      require_library 'less'
    end

  end

end

