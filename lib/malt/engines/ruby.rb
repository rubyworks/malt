require 'malt/engines/abstract'

module Malt::Engines

  # Ruby as a template engine.
  #
  #   http://
  #
  class Ruby < Abstract

    default :rb

    #
    def render(params={}, &yld)
      text = params[:text]
      file = params[:file]
      data = params[:data]
      data = make_binding(data, &yld)
      eval(text, data, file)
    end

    # Ruby compiles to Ruby. How odd. ;)
    def compile(text, file)
      text
    end

    private

    #
    def initialize_engine
    end

  end

end

