require 'malt/engines/abstract'

module Malt::Engine

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

      binding = make_binding(data, &yld)

      eval(text, binding, file)
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

