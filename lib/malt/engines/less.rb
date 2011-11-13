require 'malt/engines/abstract'

module Malt::Engine

  # LESS
  #
  #   http://lesscss.org/
  #
  # LESS is an extension of CSS. You can write LESS code just like you would write CSS,
  # except you need to compile it to CSS. That's what this class is for.
  class Less < Abstract

    default :less

    #
    def render(params)
      text = params[:text]
      into = params[:to]
      cmpr = params[:compress]

      case into
      when :css, nil
        intermediate(params).parse(text).to_css(:compress=>cmpr)
      else
        super(params)
      end
    end

    #
    def intermediate(params)
      file = params[:file]
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

