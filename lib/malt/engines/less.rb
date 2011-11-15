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
p text
        intermediate(params).parse(text).to_css(:compress=>compress)
      else
        super(params)
      end
    end

    #
    def intermediate(params={})
      file = parameters(params, :file)
      ::Less::Parser.new(:filename=>file)
    end

    #
    #def compile(text, file)
    #  intermediate # ??
    #end

  private

    # Load Less library if not already loaded.
    def initialize_engine
      return if defined? ::Less::Parser
      require_library 'less'
    end

  end

end

