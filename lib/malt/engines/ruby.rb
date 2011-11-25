require 'malt/engines/abstract'

module Malt::Engine

  # Ruby return reuslt as template engine.
  #
  # @todo deprecate ?
  # 
  # @see http://ruby-lang.org
  #
  class Ruby < Abstract

    default :rb

    #
    def render(params={}, &content)
      text, file, data = parameters(params, :text, :file, :data)

      bind = make_binding(data, &content)
      eval(text, bind, file || 'eval')
    end

    # Ruby compiles to Ruby. How odd. ;)
    def compile(params)
      params[:text] #file
    end

  private

    #
    def require_engine
    end

  end

end

