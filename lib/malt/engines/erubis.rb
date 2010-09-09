require 'malt/engines/abstract'

module Malt::Engine

  # Erubis template implementation.
  #
  #   http://www.kuwata-lab.com/erubis/
  #
  # Erubis is essentially compatibel with ERB, but it is faster.
  #
  class Erubis < Abstract

    register :erb, :rhtml

    # Render template.
    def render(params, &yld)
      text = params[:text]
      data = params[:data]
      data = make_binding(data, &yld)
      intermediate(params).result(data)
    end

    # Compile template into Ruby source code.
    def compile(params)
      text = params[:text]
      file = params[:file]
      intermediate(text, file).src
    end

    #
    def intermediate(params)
      text = params[:text]
      file = params[:file]

      opts = {}

      if params[:escape_html] || settings[:escape_html]
        ::Erubis::EscapedEruby.new(text, settings)
      else
        ::Erubis::Eruby.new(text, settings)
      end
    end

    #
    def safe
      options[:safe]
    end

    #
    def trim
      options[:trim]
    end

    ;;;; private ;;;;

    # Load ERB library if not already loaded.
    def initialize_engine
      return if defined? ::Erubius
      require_library('erubis')
    end

  end

end

